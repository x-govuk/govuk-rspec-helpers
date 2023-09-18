module GovukRSpecHelpers
  class ChooseGovukRadio

    attr_reader :page, :label_text, :hint_text

    def initialize(page:, label_text:, hint_text:)
      @label_text = label_text
      @hint_text = hint_text
      @page = page
    end

    def choose
      labels = page.all('label', text: label_text, exact_text: true, normalize_ws: true)

      if labels.size == 0
        check_for_input_id_match

        raise "Unable to find label with the text \"#{label_text}\""
      end

      @label = labels.first

      inputs_matching_label = page.all(id: @label[:for])

      if inputs_matching_label.size == 1
        @input = inputs_matching_label.first
      end

      check_that_fieldset_legend_was_specified

      if hint_text
        check_for_hint
        check_that_hint_is_associated_with_input
      end


      @label.click
    end

    private

    def check_for_input_id_match
      inputs = page.all('input', id: label_text)

      if inputs.size > 0

        matching_labels = page.all("label[for=#{label_text}]")

        if matching_labels.size > 0
          raise "Use the full label text \"#{matching_labels.first.text}\" instead of the input ID"
        end
      end
    end

    def check_that_fieldset_legend_was_specified
      if page.current_scope.is_a?(Capybara::Node::Document)

        fieldset = @label.ancestor('fieldset')
        legend = fieldset.find('legend')

        if legend
          raise "Specify the legend using: within_govuk_fieldset \"#{legend.text}\" do"
        end
      end
    end

    def check_for_hint
      radio_item = @label.ancestor('.govuk-radios__item')

      hints = radio_item.all('.govuk-hint', text: hint_text, exact_text: true, normalize_ws: true)

      if hints.size == 0
        other_hints = radio_item.all('.govuk-hint')

        if other_hints.size > 0
          raise "Found radio but could not find matching hint. Found the hint \"#{other_hints.first.text}\" instead"
        end
      end

      @hint = hints.first
    end

    def check_that_hint_is_associated_with_input
      hint_id = @hint[:id]

      if hint_id.to_s.strip == ""
        raise "Found radio and hint, but the hint is not associated with the input using aria. And an ID to the hint and Add aria-describedby= to the input with that ID."
      end

      if !@input["aria-describedby"].to_s.split(/\s+/).include?(hint_id)
        raise "Found radio and hint, but the hint is not associated with the input using aria. Add aria-describedby=#{hint_id} to the input."
      end
    end
  end

  def choose_govuk_radio(label_text, hint: nil)
    ChooseGovukRadio.new(page: page, label_text: label_text, hint_text: hint).choose
  end

  RSpec.configure do |rspec|
    rspec.include self
  end

end
