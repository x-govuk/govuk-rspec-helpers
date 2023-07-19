# frozen_string_literal: true
require "spec_helper"

RSpec.describe "summarise matcher" do

  context "when just a key and value are present" do

    let(:html) { '<dl class="govuk-summary-list">
    <div class="govuk-summary-list__row">
      <dt class="govuk-summary-list__key">
        Name
      </dt>
      <dd class="govuk-summary-list__value">
        Sarah Philips
      </dd>
    </div></dl>' }

    it "should pass an exact match on the name and key" do
      expect(html).to summarise(key: "Name", value: "Sarah Philips")
    end

    it "should should fail if key isn’t present" do
      expect {
        expect(html).to summarise(key: "Age", value: "35")
      }.to fail_with("Could not find the key ‘Age’ within\n\n #{html}")
    end

    it "should should fail on a partial match of the value" do
      expect {
        expect(html).to summarise(key: "Name", value: "Sarah")
      }.to fail_with("Expected ‘Name’ value to be ‘Sarah’ but was ‘Sarah Philips’")
    end
  end

  context "when a key, value and actions are present" do

    let(:html) { '<dl class="govuk-summary-list">
  <div class="govuk-summary-list__row">
    <dt class="govuk-summary-list__key">
      Name
    </dt>
    <dd class="govuk-summary-list__value">
      Sarah Philips
    </dd>
    <dd class="govuk-summary-list__actions">
      <a class="govuk-link" href="/name">
        Change<span class="govuk-visually-hidden"> name</span>
      </a>
    </dd>
  </div>
  <div class="govuk-summary-list__row">
    <dt class="govuk-summary-list__key">
      Date of birth
    </dt>
    <dd class="govuk-summary-list__value">
      5 January 1978
    </dd>
    <dd class="govuk-summary-list__actions">
      <a class="govuk-link" href="/dob">
        Change<span class="govuk-visually-hidden"> date of birth</span>
      </a>
    </dd>
  </div></dl>' }

    it "should pass an exact matches for the name, key and action" do
      expect(html).to summarise(key: "Name", value: "Sarah Philips", action: {
        text: "Change name", href: "/name"
      })
      expect(html).to summarise(key: "Date of birth", value: "5 January 1978", action: {
        text: "Change date of birth", href: "/dob"
      })
    end

    it "should fail if the full action label isn’t given" do
      expect {
        expect(html).to summarise(key: "Name", value: "Sarah Philips", action: {
          text: "Change", href: "/name"
        })
      }.to fail_with(/Could not find the link ‘Change’ within HTML:/)
    end

    it "should fail if the link href doesn’t match" do
      expect {
        expect(html).to summarise(key: "Name", value: "Sarah Philips", action: {
          text: "Change name", href: "/dob"
        })
      }.to fail_with("Expected link href to be /dob, was /name")
    end
  end

end
