---
title: Links
layout: sub-navigation
order: 3
---

This helper is a drop-in replacement for the standard `click_link` helper, which adds some additional usability and accessibility checks.

Use this within tests that navigate between multiple pages.

Here’s a simple example:

```ruby
  scenario "Navigating between pages" do
    visit "/"

    click_govuk_link "Departments"
    expect(page).to have_content("Departments")

    click_govuk_link "Department for Education"
    expect(page).to have_content("Department for Education")

    click_govuk_link "Back"
    expect(page).to have_content("Departments")
  end
```

The helper will check that:

* there aren’t 2 or more links with the same link text
* the link has the `govuk-link` class, or another link class from the GOV.UK Design System
* the link text isn’t an ambiguous word like "Change"
* the full link text is specified (including any visually-hidden text) rather than a partial match
* if the link is set to open in a new tab, then the phrase "opens in new tab" is included within the link text
* the link isn’t styled as a button (if it is, use [`click_govuk_button`](/click-govuk-button) instead).
