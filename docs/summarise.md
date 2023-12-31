---
title: Summary lists
layout: sub-navigation
order: 8
---

Use this helper to test that the [summary list component](https://design-system.service.gov.uk/components/summary-list/) is visible on the page with the correct content, for example on a check your answers page.

Add this code:

```ruby
expect(html).to summarise(
  key: "Name",
  value: "Sarah Philips",
  action: {
    text: "Change name",
    href: "/name"
  }
)
expect(html).to summarise(
  key: "Date of birth",
  value: "5 January 1978",
  action: {
    text: "Change date of birth",
    href: "/dob"
  }
)
```

This will test that:

* the keys and values are present, and in the same row as each other
* the action links are present, and link to the pages specified

If you don’t have any change links, those can be dropped:

```ruby
expect(html).to summarise(
  key: "Name",
  value: "Sarah Philips"
)
expect(html).to summarise(
  key: "Date of birth",
  value: "5 January 1978"
)
```
