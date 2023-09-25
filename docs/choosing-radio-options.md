---
title: Radio options
layout: sub-navigation
order: 7
---

This helper is a drop-in replacement for the standard `choose` helper which adds some additional usability and accessibility checks.

Radio options should always be nested within a fieldset, so you need to combine this helper with the [`within_govuk_fieldset`](within-fieldsets) helper.

Here’s a basic example:

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

* there is a label with the given text
* a radio input is correctly associated with that label using the `for` attribute
* the label and input are both nested within a fieldset that has the legend given

## Hints

If a radio option has a hint, you can specify this to check that it is correctly associated with the field using `aria-describedby`:

```ruby
scenario "Selecting a radio option which has a hint" do
  visit "/"

  within_govuk_fieldset "What is the event about?" do
    choose_govuk_radio "Technology", hint: "For example, the Web"
  end
  click_govuk_button "Continue"

  expect(page).to have_content("Technology")
end
```
