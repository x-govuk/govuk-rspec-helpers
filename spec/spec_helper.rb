# frozen_string_literal: true
require 'capybara/rspec'
require 'rspec/matchers/fail_matchers'

require "govuk_rspec_helpers"


require 'test_app'

Capybara.app = TestApp


RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.include RSpec::Matchers::FailMatchers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
