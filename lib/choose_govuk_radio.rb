module GovukRSpecHelpers
  class ChooseGovukRadio

    attr_reader :page, :label_text

    def initialize(page:, label_text:)
      @label_text = label_text
      @page = page
    end

    def choose
      labels = page.all('label', text: label_text, exact_text: true, normalize_ws: true)

      if labels.size == 0
        check_for_input_id_match

        raise "Unable to find label with the text \"#{label_text}\""
      end

      @label = labels.first

      check_that_fieldset_legend_was_specified

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

  end

  def choose_govuk_radio(label_text)
    ChooseGovukRadio.new(page: page, label_text: label_text).choose
  end

  RSpec.configure do |rspec|
    rspec.include self
  end

end
