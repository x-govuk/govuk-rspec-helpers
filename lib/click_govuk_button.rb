module GovukRSpecHelpers
  class ClickButton

    attr_reader :page, :button_text, :disabled

    def initialize(page:, button_text:, disabled: false)
      @page = page
      @button_text = button_text
      @disabled = disabled
    end

    def click
      @buttons = page.all('button', text: button_text, exact_text: true)

      if @buttons.empty?
        @buttons = page.all('a.govuk-button', text: button_text, exact_text: true)
      end

      if @buttons.empty?
        @buttons = page.all("input[type=submit][value=\"#{Capybara::Selector::CSS.escape(button_text)}\"]")
      end

      if @buttons.size == 0
        check_for_inexact_match
        raise "Unable to find button \"#{button_text}\""
      end

      check_that_button_text_is_unique_on_the_page

      @button = @buttons.first

      check_data_module_attribute_is_present
      check_role_is_present_if_button_is_a_link
      check_button_is_not_draggable_if_button_is_a_link
      check_if_button_is_disabled
      check_for_govuk_class

      @button.click unless disabled
    end

  private

    def check_for_inexact_match
      buttons_without_exact_match = page.all('button', text: button_text)

      if buttons_without_exact_match.size > 0
        raise "Unable to find button \"#{button_text}\" but did find button with the text \"#{buttons_without_exact_match.first.text}\" - include the full button text including any visually-hidden text"
      end
    end

    def check_that_button_text_is_unique_on_the_page
      if @buttons.size > 1
        raise "There are #{@buttons.size} buttons with the text \"#{button_text}\" - buttons should be unique within a page"
      end
    end

    def check_data_module_attribute_is_present
      if @button["data-module"] != "govuk-button"
        raise "Button is missing the data-module=\"govuk-button\" attribute"
      end
    end

    def check_role_is_present_if_button_is_a_link
      if @button.tag_name == 'a' && @button["role"] != "button"
        raise "Button found, but `role=\"button\"` is missing, this is needed on links styled as buttons"
      end
    end

    def check_button_is_not_draggable_if_button_is_a_link
      if @button.tag_name == 'a' && @button["draggable"] != "false"
        raise "Button found, but `draggable=\"false\"` is missing, this is needed on links styled as buttons"
      end
    end

    def check_if_button_is_disabled
      button_classes = @button[:class].to_s.split(/\s/).collect(&:strip)

      if @button["disabled"] == "disabled" && !disabled
        raise "Button is disabled. Avoid using disabled buttons as they have poor contrast and can confuse users. If this is unavoidable, use click_govuk_button(\"#{button_text}\", disabled: true)"
      end

      if disabled && !button_classes.include?('govuk-button--disabled')
        raise "Disabled button is missing the govuk-button--disabled class"
      end

      if disabled && @button["aria-disabled"].to_s != "true"
        raise 'Disabled button is missing aria-disabled="true"'
      end
    end

    def check_for_govuk_class
      button_classes = @button[:class].to_s.split(/\s/).collect(&:strip)
      if button_classes.empty?
        raise "Button is missing a class, should contain \"govuk-button\""
      elsif !button_classes.include?('govuk-button')
        raise "Button is missing the govuk-button class, contains #{button_classes.join(', ')}"
      end
    end

  end

  def click_govuk_button(button_text, disabled: false)
    ClickButton.new(page: page, button_text: button_text, disabled: disabled).click
  end

  RSpec.configure do |rspec|
    rspec.include self
  end
end
