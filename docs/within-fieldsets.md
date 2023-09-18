---
title: Fieldsets
layout: sub-navigation
order: 4
---

This helper is a drop-in replacement for the standard `within_fieldset` helper which adds some additional usability and accessibility checks.

This can be used with either radios or checkboxes.

Here’s an example:

```ruby
scenario "Selecting a radio option" do
  visit "/"

  within_govuk_fieldset "Where do you live?" do
    choose_govuk_radio "Wales"
  end
  click_govuk_button "Continue"

  expect(page).to have_content("Wales")
end
```

The helper will check that:

* there is a fieldset labelled by the legend given

## Hints

If a fieldset contains a hint, you can specify this to check that the fieldset is correctly associated with the hint using `aria-describedby`:

```ruby
scenario "Selecting a radio option from a fieldset which has a hint" do
  visit "/"

  within_govuk_fieldset "How would you prefer to be contacted?",
    hint: "Select one option" do
    choose_govuk_radio "Email"
  end
  click_govuk_button "Continue"

  expect(page).to have_content("Email")
end
```
