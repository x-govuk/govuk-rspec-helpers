---
title: Buttons
layout: sub-navigation
order: 2
---

This helper is a drop-in replacement for the standard `click_button` helper which adds some additional usability and accessibility checks.

As well as working with standard `<button>` elements, the helper should also be used for links that are styled as buttons.

Use this within tests that fill in forms across multiple pages.

Here’s a simple example:

```ruby
scenario "Completing the form" do
  visit "/"

  click_govuk_button "Start now"

  fill_in "Name", with: "Jane Smith"
  click_govuk_button "Continue"

  fill_in "Email address", with: "jane@example.com"
  click_govuk_button "Continue"

  expect(page).to have_content("Check your answers")
end
```

The helper will check that:

* there aren’t 2 or more buttons with the same text
* the button has the `govuk-button` class
* that `data-module="govuk-button"` has been added
* if the button is a link styled as button, that `draggable="false"` and `role="button"` have been added
* the button is not disabled

## Disabled buttons

Disabled buttons are [strongly discouraged](https://design-system.service.gov.uk/components/button/#disabled-buttons) as they have poor contrast and can confuse some users.

If you really need to use disabled buttons, or have some user research showing it makes your service easier to understand, you can use the helper to click these by adding `disabled: true`. Clicking disabled buttons will not submit a form.

```ruby
scenario "Clicking a disabled button" do
  visit('/')
  click_govuk_button "Send application", disabled: true

  expect(page.current_path).to eql("/")
end
```
