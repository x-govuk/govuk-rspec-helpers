---
layout: sub-navigation
title: Get started
order: 1
---

## Requirements

* Ruby (3.1.0 or above)
* RSpec (3.0 or above)

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
