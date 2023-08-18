# frozen_string_literal: true

require_relative "lib/govuk_rspec_helpers"

Gem::Specification.new do |spec|
  spec.name = "govuk-rspec-helpers"
  spec.version = 0.1
  spec.authors = ["Frankie Roberto"]
  spec.email = ["frankie@frankieroberto.com"]

  spec.summary = "RSpec test helpers for GOV.UK services"
  spec.description = ""
  spec.homepage = "https://x-govuk.github.io"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.4"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara", '>= 3.24'
end
