
def click_govuk_button(button_text)

  buttons = all('button', text: button_text, exact_text: true)

  if buttons.empty?
    buttons = all('a.govuk-button', text: button_text, exact_text: true)
  end

  if buttons.size == 0

    buttons_without_exact_match = all('button', text: button_text)

    if buttons_without_exact_match.size > 0
      raise "Unable to find button \"#{button_text}\" but did find button with the text \"#{buttons_without_exact_match.first.text}\" - include the full button text including any visually-hidden text"
    else
      raise "Unable to find button \"#{button_text}\""
    end
  elsif buttons.size > 1
    raise "There are #{buttons.size} buttons with the text \"#{button_text}\" - buttons should be unique within a page"
  end

  button = buttons.first

  button_classes = button[:class].to_s.split(/\s/).collect(&:strip)

  if button["data-module"] != "govuk-button"
    raise "Button is missing the data-module=\"govuk-button\" attribute"
  end

  if button.tag_name == 'a' && button["role"] != "button"
    raise "Button found, but `role=\"button\"` is missing, this is needed on links styled as buttons"
  end

  if button_classes.include?('govuk-button')
    button.click
  elsif button_classes.empty?
    raise "Button is missing a class, should contain \"govuk-button\""
  else
    raise "Button is missing the govuk-button class, contains #{button_classes.join(', ')}"
  end
end
