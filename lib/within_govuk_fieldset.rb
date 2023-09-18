module GovukRSpecHelpers
  class WithinGovukFieldset

    attr_reader :page, :legend_text, :hint, :block

    def initialize(page:, legend_text:, hint:, block:)
      @legend_text = legend_text
      @hint = hint
      @page = page
      @block = block
    end

    def within

      legends = page.all('legend', text: legend_text, exact_text: true, normalize_ws: true)

      if legends.size == 0
        check_for_fieldset_id_match
        raise "No fieldset found with matching legend"
      end

      legend = legends.first
      @fieldset = legend.ancestor('fieldset')

      check_hint

      @page.within(@fieldset) do
        block.call
      end
    end

    private

    def check_hint
      if hint
        hint_elements = @fieldset.all('.govuk-hint', text: hint, exact_text: true, normalize_ws: true)

        if hint_elements.size == 0
          raise "Count not find hint with that text"
        end

        hint_id = hint_elements.first[:id]

        if !@fieldset["aria-describedby"].to_s.split(/\s+/).include?(hint_id)
          raise "Found hint but it is not associated with the fieldset using aria-describedby"
        end

      end
    end

    def check_for_fieldset_id_match
      matching_fieldsets = page.all("fieldset[id=#{Capybara::Selector::CSS.escape(legend_text)}]")

      if matching_fieldsets.size > 0

        legends = matching_fieldsets.first.all('legend')

        if legends.size > 0
          raise "Use the full legend text \"#{legends.first.text}\" instead of the fieldset ID"
        end
      end
    end

  end

  def within_govuk_fieldset(legend_text, hint: nil, &block)
    WithinGovukFieldset.new(page: page, legend_text: legend_text, hint: hint, block: block).within
  end

  RSpec.configure do |rspec|
    rspec.include self
  end

end
