---
title: Error summaries
layout: sub-navigation
order: 7
---

Use this helper to test that the [error summary component](https://design-system.service.gov.uk/components/error-summary/) is visible on the page with the correct content.

Add this code:

```ruby
expect(html).to summarise_errors([
  "Enter your full name",
  "Select if you are British, Irish or a citizen of a different country"
])
```

This will test that:

* the page title has an `Error:` prefix
* the error summary component is present
* all of the errors given in the array are present, and in the same order
* all the errors link to a form input
* no other errors are listed
