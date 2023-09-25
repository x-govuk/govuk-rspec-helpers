---
title: Checkboxes
layout: sub-navigation
order: 3
---

These helpers are a drop-in replacements for the standard `check` and `uncheck` helpers which add some additional usability and accessibility checks.

Here’s a basic example:

```ruby
scenario "Changing a checkbox answer" do
  visit "/"

  within_govuk_fieldset "Which types of waste do you transport?",
    hint: "Select all that apply" do

    uncheck_govuk_checkbox "Waste from mines or quarries"
    check_govuk_checkbox "Waste from animal carcasses"
  end

  click_govuk_button "Continue"

  expect(page).to have_content("Waste from animal carcasses")
  expect(page).not_to have_content("Waste from mines or quarries")
end
```

These helpers will check that:

* there is a label with the given text
* a checkbox input is correctly associated with that label using the `for` attribute
* any hints are correctly associated with the checkbox inputs
* the labels and inputs have the right classes from GOV.UK Design System
* the checkbox was not already checked or unchecked

## Hints

If a checkbox has a hint, you can specify this to check that it is correctly associated with the field using `aria-describedby`:

```ruby
scenario "Checking a checkbox which has a hint" do
  visit "/"

  within_govuk_fieldset "What is your nationality?",
    hint: "If you have dual nationality, select all options that are relevant to you." do

    check_govuk_checkbox "British", hint: "including English, Scottish, Welsh and Northern Irish"
  end

  click_govuk_button "Continue"

  expect(page).to have_content("British")
end
```
