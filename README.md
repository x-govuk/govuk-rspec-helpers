# GOV.UK rspec helpers

This gem providers a set of helpers to make it easier to test GOV.UK services using the rspec framework.

The standard rspec helpers work well for testing standard HTML components like links, buttons and form inputs. This gem lets you test these more bespoke components from the GOV.UK Design System:

* Error summary
* Summary list
* Task list (coming soon)

This is a pre-release. Feedback is welcome.

## Installation

Install the gem by adding it to your `Gemfile`:

```bash
gem install govuk-rspec-helpers
```

You should also have already added `rspec`.

## Using the helpers

You can use the helpers to add expectations to either feature or request specs.

### Expecting error summaries

Add this code to expect there to be an error summary on the page:

```ruby
  expect(html).to summarise_errors([
    "Enter your full name",
    "Select if you are British, Irish or a citizen of a different country"
  ])
```

This will test that:

* The page title has an `Error: ` prefix
* The error summary component is present
* All of the errors given in the array are present, and in the same order
* No other errors are listed
* All the errors link to a form input

### Expecting summary lists

Add this code to expect a summary list to contain certain values, for example on a Check your answers page:

```ruby
  expect(html).to summarise(key: "Name", value: "Sarah Philips", action: {
    text: "Change name", href: "/name"
  })
  expect(html).to summarise(key: "Date of birth", value: "5 January 1978", action: {
    text: "Change date of birth", href: "/dob"
  })
end
```

This will test that:

* the keys and values are present, and in the same row as each other
* the action links are present, and link to the pages specified

If you don’t have any change links, those can be dropped:

```ruby
  expect(html).to summarise(key: "Name", value: "Sarah Philips")
  expect(html).to summarise(key: "Date of birth", value: "5 January 1978")
```
