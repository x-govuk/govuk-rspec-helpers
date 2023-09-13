module GovukRSpecHelpers
  class FillInGovUKTextField

    attr_reader :page, :label, :hint, :with

    def initialize(page:, label:, hint:, with:)
      @page = page
      @label = label
      @hint = hint
      @with = with
    end

    def fill_in
      labels = page.all('label', text: label, exact_text: true, normalize_ws: true)

      if labels.size == 0
        check_for_inexact_label_match
        check_for_field_name_match

        raise "Unable to find label with the text #{label}"
      end

      @label = labels.first

      check_label_has_a_for_attribute

      label_for = @label[:for]
      @inputs = page.all(id: label_for)

      check_label_is_associated_with_a_field
      check_there_is_only_1_element_with_the_associated_id

      @input = @inputs.first

      check_associated_element_is_a_form_field
      check_input_type_is_text

      aria_described_by_ids = @input["aria-describedby"].to_s.strip.split(/\s+/)

      @described_by_elements = []

      if aria_described_by_ids.size > 0
        aria_described_by_ids.each do |aria_described_by_id|

          check_there_is_only_one_element_with_id(aria_described_by_id)
          @described_by_elements << page.find(id: aria_described_by_id)

        end
      end

      if hint
        check_field_is_described_by_a_hint
        check_hint_matches_text_given
      end

      @input.set(with)
    end

    private

    def check_for_inexact_label_match
      labels_not_using_exact_match = page.all('label', text: label)
      if labels_not_using_exact_match.size > 0
        raise "Unable to find label with the text \"#{label}\" but did find label with the text \"#{labels_not_using_exact_match.first.text}\" - use the full label text"
      end
    end

    def check_for_field_name_match
      inputs_matching_name = page.all("input[name=\"#{label}\"]")

      if inputs_matching_name.size > 0

        input_matching_name = inputs_matching_name.first

        labels = page.all("label[for=\"#{input_matching_name['id']}\"]")

        if labels.size > 0
          raise "Use the full label text \"#{labels.first.text}\" instead of the field name"
        end
      end
    end

    def check_label_has_a_for_attribute
      if @label[:for].to_s.strip == ""
        raise "Found the label but it is missing a \"for\" attribute to associate it with an input"
      end
    end

    def check_label_is_associated_with_a_field
      if @inputs.size == 0
        raise "Found the label but there is no field with the ID \"#{@label[:for]}\" which matches the label‘s \"for\" attribute"
      end
    end

    def check_there_is_only_1_element_with_the_associated_id
      if @inputs.size > 1
        raise "Found the label but there there are #{@inputs.size} elements with the ID \"#{@label[:for]}\" which matches the label‘s \"for\" attribute"
      end
    end

    def check_associated_element_is_a_form_field
      if !['input', 'textarea', 'select'].include?(@input.tag_name)
        raise "Found the label but but it is associated with a <#{@input.tag_name}> element instead of a form field"
      end
    end

    def check_input_type_is_text
      raise "Found the field, but it has type=\"#{@input[:type]}\", expected type=\"text\"" unless @input[:type] == "text"
    end

    def check_field_is_described_by_a_hint
      if @described_by_elements.size == 0
        check_if_the_hint_exists_but_is_not_associated_with_field

        raise "Found the field but could not find the hint \"#{hint}\""
      end
    end

    def check_if_the_hint_exists_but_is_not_associated_with_field
      if page.all('.govuk-hint', text: hint).size > 0
        raise "Found the field and the hint, but not field is not associated with the hint using aria-describedby"
      end
    end

    def check_hint_matches_text_given
      hint_matching_id = @described_by_elements.find {|element| element[:class].include?("govuk-hint") }
      if hint_matching_id.text != hint
        raise "Found the label but the associated hint is \"#{hint_matching_id.text}\" not \"#{hint}\""
      end
    end

    def check_there_is_only_one_element_with_id(aria_described_by_id)
      elements_matching_id = page.all(id: aria_described_by_id)
      if elements_matching_id.size == 0
        raise "Found the field but it has an \"aria-describedby=#{aria_described_by_id}\" attribute and no hint with that ID exists"
      elsif elements_matching_id.size > 1
        raise "Found the field but it has an \"aria-describedby=#{aria_described_by_id}\" attribute and 2 elements with that ID exist"
      end
    end

  end

  def fill_in_govuk_text_field(label, hint: nil, with:)
    FillInGovUKTextField.new(page:, label:, hint:, with:).fill_in
  end

  RSpec.configure do |rspec|
    rspec.include self
  end
end
