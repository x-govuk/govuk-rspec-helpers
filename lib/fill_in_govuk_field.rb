module GovukRSpecHelpers
  class FillInGovUKField

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

        labels_not_using_exact_match = page.all('label', text: label)
        inputs_matching_name = page.all("input[name=\"#{label}\"]")


        if labels_not_using_exact_match.size > 0
          raise "Unable to find label with the text \"#{label}\" but did find label with the text \"#{labels_not_using_exact_match.first.text}\" - use the full label text"

        elsif inputs_matching_name.size > 0

          input_matching_name = inputs_matching_name.first

          labels = page.all("label[for=\"#{input_matching_name['id']}\"]")

          if labels.size > 0
            raise "Use the full label text \"#{labels.first.text}\" instead of the field name"
          end

        else
          raise "Unable to find label with the text #{label}"
        end
      end

      label = labels.first

      label_for = label[:for]

      raise "Found the label but it is missing a \"for\" attribute to associate it with an input" if label_for.to_s.strip == ""

      inputs = page.all(id: label_for)

      raise "Found the label but there is no field with the ID \"#{label_for}\" which matches the label‘s \"for\" attribute" if inputs.size == 0
      raise "Found the label but there there are #{inputs.size} elements with the ID \"#{label_for}\" which matches the label‘s \"for\" attribute" if inputs.size > 1

      input = inputs.first
      raise "Found the label but but it is associated with a <#{input.tag_name}> element instead of a form field" if !['input', 'textarea', 'select'].include?(input.tag_name)

      aria_described_by_ids = input["aria-describedby"].to_s.strip.split(/\s+/)

      described_by_elements = []

      if aria_described_by_ids.size > 0
        aria_described_by_ids.each do |aria_described_by_id|
          elements_matching_id = page.all(id: aria_described_by_id)

          if elements_matching_id.size == 0
            raise "Found the field but it has an \"aria-describedby=#{aria_described_by_id}\" attribute and no hint with that ID exists"
          elsif elements_matching_id.size > 1
            raise "Found the field but it has an \"aria-describedby=#{aria_described_by_id}\" attribute and 2 elements with that ID exist"
          else
            described_by_elements << elements_matching_id.first
          end
        end
      end

      if hint

        if described_by_elements.size == 0

          if page.all('.govuk-hint', text: hint).size > 0
            raise "Found the field and the hint, but not field is not associated with the hint using aria-describedby"
          else
            raise "Found the field but could not find the hint \"#{hint}\""
          end

        else
          hint_matching_id = described_by_elements.find {|element| element[:class].include?("govuk-hint") }
        end

        if hint_matching_id.text != hint
          raise "Found the label but the associated hint is \"#{hint_matching_id.text}\" not \"#{hint}\""
        end

      end

      input.set(with)
    end
  end

  def fill_in_govuk_field(label, hint: nil, with:)
    FillInGovUKField.new(page:, label:, hint:, with:).fill_in
  end

  RSpec.configure do |rspec|
    rspec.include self
  end
end
