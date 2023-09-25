module GovukRSpecHelpers
  class GovukCheckbox

    attr_reader :page, :label_text, :hint_text

    def initialize(page:, label_text:, hint_text:)
      @label_text = label_text
      @hint_text = hint_text
      @page = page
    end

    def check
      set_checked(true)
    end

    def uncheck
      set_checked(false)
    end

    private

    def set_checked(checked)
      labels = page.all('label', text: label_text, exact_text: true, normalize_ws: true)

      if labels.size == 0
        check_for_input_id_match

        raise "Unable to find label with the text \"#{label_text}\""
      elsif labels.size > 1
        raise "Found #{labels.size} labels with the same text. Checkbox labels should be unique within a fieldset."
      end

      @label = labels.first

      check_label_has_a_for_attribute

      inputs_matching_label = page.all(id: @label[:for])

      if inputs_matching_label.size == 1
        @input = inputs_matching_label.first
      elsif inputs_matching_label.size == 0
        raise "Found the label but it is not associated with an checkbox, did not find a checkbox with the ID \"#{@label[:for]}\"."
      else
        raise "Found #{inputs_matching_label.size} elements with id=\"#{@label[:for]}\". IDs must be unique."
      end

      check_input_type_is_radio

      check_label_classes
      check_input_class

      hints = @label.ancestor('.govuk-checkboxes__item')
        .all('.govuk-hint', text: hint_text, exact_text: true, normalize_ws: true)

      @hint = hints.first

      check_for_hint if hint_text
      check_that_hint_is_associated_with_input if @hint
      check_that_checkbox_not_checked if checked
      check_that_checkbox_is_checked if !checked

      @label.click
    end

    def check_for_input_id_match
      inputs = page.all('input', id: label_text)

      if inputs.size > 0

        matching_labels = page.all("label[for=#{label_text}]")

        if matching_labels.size > 0
          raise "Use the full label text \"#{matching_labels.first.text}\" instead of the input ID"
        end
      end
    end

    def check_label_has_a_for_attribute
      if !@label[:for]
        raise 'Found the label but it is not associated with an checkbox, was missing a for="" attribute'
      end
    end

    def check_input_type_is_radio
      if @input[:type] == 'radio'
        raise "Found the label, but it is associated with an input with type=\"#{@input[:type]}\" not a checkbox"
      end
    end

    def check_label_classes
      label_classes = @label[:class].to_s.split(/\s+/)

      if !label_classes.include?('govuk-label') && !label_classes.include?('govuk-checkboxes__label')
        raise "Found label but it is missing the govuk-label and govuk-checkboxes__label classes"
      elsif !label_classes.include?('govuk-label')
        raise "Found label but it is missing the govuk-label class"
      elsif !label_classes.include?('govuk-checkboxes__label')
        raise "Found label but it is missing the govuk-checkboxes__label class"
      end
    end

    def check_input_class
      input_classes = @input[:class].to_s.split(/\s+/)

      if !input_classes.include?('govuk-checkboxes__input')
        raise "Found checkbox but it is missing the govuk-checkboxes__input class"
      end
    end


    def check_for_hint
      if @hint.nil? || @hint.text != hint_text
        other_hints = @label.ancestor('.govuk-checkboxes__item').all('.govuk-hint')

        if other_hints.size > 0 && hint_text
          raise "Found checkbox but could not find matching hint. Found the hint \"#{other_hints.first.text}\" instead"
        end
      end
    end

    def check_that_hint_is_associated_with_input
      hint_id = @hint[:id]

      if hint_id.to_s.strip == ""
        if hint_text
          raise "Found checkbox and hint, but the hint is not associated with the input using aria. And an ID to the hint and Add aria-describedby= to the input with that ID."
        else
          raise "Found checkbox, but also found a hint that is not associated with the input using aria. And an ID to the hint and Add aria-describedby= to the input with that ID."
        end
      end

      if !@input["aria-describedby"].to_s.split(/\s+/).include?(hint_id)
        if hint_text
          raise "Found checkbox and hint, but the hint is not associated with the input using aria. Add aria-describedby=\"#{hint_id}\" to the input."
        else
          raise "Found checkbox, but also found a hint that is not associated with the input using aria. Add aria-describedby=\"#{hint_id}\" to the input."
        end
      end
    end

    def check_that_checkbox_not_checked
      if @input[:checked]
        raise "Found checkbox, but it was already checked"
      end
    end

    def check_that_checkbox_is_checked
      if !@input[:checked]
        raise "Found checkbox, but it was already unchecked"
      end
    end

  end

  def check_govuk_checkbox(label_text, hint: nil)
    GovukCheckbox.new(page: page, label_text: label_text, hint_text: hint).check
  end

  def uncheck_govuk_checkbox(label_text, hint: nil)
    GovukCheckbox.new(page: page, label_text: label_text, hint_text: hint).uncheck
  end

  RSpec.configure do |rspec|
    rspec.include self
  end

end
