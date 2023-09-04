---
order: 2
title: Error summaries
layout: sub-navigation
---

Use this helper to test that the [Error summary component](https://design-system.service.gov.uk/components/error-summary/) is visible on the page with the correct content.

Add this code:

```ruby
  expect(html).to summarise_errors([
    "Enter your full name",
    "Select if you are British, Irish or a citizen of a different country"
  ])
```

This will test that:

* The page title has an `Error:` prefix
* The error summary component is present
* All of the errors given in the array are present, and in the same order
* No other errors are listed
* All the errors link to a form input
