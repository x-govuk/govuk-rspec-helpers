---
layout: sub-navigation
title: Get started
order: 1
---

## Requirements

* Ruby
* RSpec

## Installation

Install the gem by adding it to your `Gemfile` within the `test` group:

```Gemfile
group :test do
  # Other gems used for testing
  gem "govuk-rspec-helpers"
end
```

## Setup

Add this to your `spec_helper.rb`:

```ruby
require "govuk_rspec_helpers"
```
