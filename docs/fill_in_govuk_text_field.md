---
title: Text fields
layout: sub-navigation
order: 4
---

This helper is a drop-in replacement for the standard `fill_in` helper, which adds some additional usability and accessibility checks.

Use this within tests that navigate between multiple pages.

Here’s a simple example:

```ruby
scenario "Filling in an event name" do
  visit "/"

  fill_in_govuk_text_field("Event name", with: "Design System Day")
  click_govuk_button("Continue")

  expect(page).to have_content("Design System Day")
end
```

The helper will check that:

* there is a label with the given text
* a text field is correctly associated with that label using the `for` attribute

## Hints

If a text field has a hint, you can check that this is correctly associated with the field.

```ruby
scenario "Filling in an event name" do
  visit "/"

  fill_in_govuk_text_field("What is the name of the event?",
    hint: "The name you’ll use on promotional material",
    with: "Design System Day"
  )
  click_govuk_button("Continue")

  expect(page).to have_content("Design System Day")
end
```
