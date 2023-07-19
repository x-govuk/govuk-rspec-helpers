# frozen_string_literal: true
require "spec_helper"

RSpec.describe "summarise errors matcher" do

  context "with correct HTML" do

    let(:html) { '
    <title>Error: Your details</title>
    <div class="govuk-error-summary" data-module="govuk-error-summary">
      <div role="alert">
        <h2 class="govuk-error-summary__title">
          There is a problem
        </h2>
        <div class="govuk-error-summary__body">
          <ul class="govuk-list govuk-error-summary__list">
            <li>
              <a href="#name">Enter your full name</a>
            </li>
            <li>
              <a href="#nationality">Select if you are British, Irish or a citizen of a different country</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="govuk-form-group govuk-form-group--error">
      <label class="govuk-label" for="full-name-input">
        Full name
      </label>
      <p id="full-name-input-error" class="govuk-error-message">
        <span class="govuk-visually-hidden">Error:</span> Enter your full name
      </p>
      <input class="govuk-input govuk-input--error" id="full-name-input" name="name" type="text" aria-describedby="full-name-input-error" autocomplete="name">
    </div>
    <div class="govuk-form-group govuk-form-group--error">
      <fieldset class="govuk-fieldset" aria-describedby="nationality-hint nationality-error">
        <legend class="govuk-fieldset__legend">
          What is your nationality?
        </legend>
        <div id="nationality-hint" class="govuk-hint">
          If you have dual nationality, select all options that are relevant to you.
        </div>
        <p id="nationality-error" class="govuk-error-message">
          <span class="govuk-visually-hidden">Error:</span> Select if you are British, Irish or a citizen of a different country
        </p>
        <div class="govuk-checkboxes" data-module="govuk-checkboxes">
          <div class="govuk-checkboxes__item">
            <input class="govuk-checkboxes__input" id="nationality" name="nationality" type="checkbox" value="british" aria-describedby="nationality-item-hint">
            <label class="govuk-label govuk-checkboxes__label" for="nationality">
              British
            </label>
            <div id="nationality-item-hint" class="govuk-hint govuk-checkboxes__hint">
              including English, Scottish, Welsh and Northern Irish
            </div>
          </div>
          <div class="govuk-checkboxes__item">
            <input class="govuk-checkboxes__input" id="nationality-2" name="nationality" type="checkbox" value="irish">
            <label class="govuk-label govuk-checkboxes__label" for="nationality-2">
              Irish
            </label>
          </div>
          <div class="govuk-checkboxes__item">
            <input class="govuk-checkboxes__input" id="nationality-3" name="nationality" type="checkbox" value="other">
            <label class="govuk-label govuk-checkboxes__label" for="nationality-3">
              Citizen of another country
            </label>
          </div>
        </div>
      </fieldset>
    </div>
    ' }

    it "should pass if all errors listed" do
      expect(html).to summarise_errors([
        "Enter your full name",
        "Select if you are British, Irish or a citizen of a different country"
      ])
    end

    it "should fail if an error is missing" do
      expect {
        expect(html).to summarise_errors([
          "Enter your full name",
          "Select if you are British, Irish or a citizen of a different country",
          "Choose an option"
        ])
      }.to fail_with("Missing error message: ‘Choose an option’")
    end

    it "should fail if the errors are listed in the wrong order" do
      expect {
        expect(html).to summarise_errors([
          "Select if you are British, Irish or a citizen of a different country",
          "Enter your full name"
        ])
      }.to fail_with("Error messages appear in a different order")
    end

    it "should fail if an extra error is present" do
      expect {
        expect(html).to summarise_errors([
          "Enter your full name"
        ])
      }.to fail_with("An extra error message is present")
    end
  end

  context "with a missing <title> tag" do
    let(:html) { "<div>Enter your full name</div>" }

    it "should fail" do
      expect {
        expect(html).to summarise_errors([
          "Enter your full name"
        ])
      }.to fail_with("Missing <title> tag")
    end

  end

  context "with a <title> tag missing the Error: prefix" do
    let(:html) { "<title>Your details</title>" }

    it "should fail" do
      expect {
        expect(html).to summarise_errors([
          "Enter your full name"
        ])
      }.to fail_with("Title tag is missing the error prefix: ‘Your details’")
    end

  end

  context "with a missing error summary title" do

    let(:html) { '<title>Error: Your details</title>
    <div class="govuk-error-summary" data-module="govuk-error-summary">
      <div role="alert">
        <div class="govuk-error-summary__body">
          <ul class="govuk-list govuk-error-summary__list">
            <li>
              <a href="#name">Enter your full name</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="govuk-form-group govuk-form-group--error">
      <label class="govuk-label" for="full-name-input">
        Full name
      </label>
      <p id="full-name-input-error" class="govuk-error-message">
        <span class="govuk-visually-hidden">Error:</span> Enter your full name
      </p>
      <input class="govuk-input govuk-input--error" id="full-name-input" name="name" type="text" aria-describedby="full-name-input-error" autocomplete="name">
    </div>
    '
    }

    it "should fail" do
      expect {
        expect(html).to summarise_errors([
          "Enter your full name"
        ])
      }.to fail_with("Missing an error summary title")
    end
  end

  context "with an error message that isn’t a link" do

    let(:html) { '<title>Error: Your details</title>
    <div class="govuk-error-summary" data-module="govuk-error-summary">
      <div role="alert">
        <h2 class="govuk-error-summary__title">
          There is a problem
        </h2>
        <div class="govuk-error-summary__body">
          <ul class="govuk-list govuk-error-summary__list">
            <li>
              Enter your full name
            </li>
          </ul>
        </div>
      </div>
    </div>'
    }

    it "should fail" do
      expect {
        expect(html).to summarise_errors([
          "Enter your full name"
        ])
      }.to fail_with("Error message ‘Enter your full name’ isn’t linked to anything")
    end
  end

  context "with an error message that has an broken link" do

    let(:html) { '<title>Error: Your details</title>
    <div class="govuk-error-summary" data-module="govuk-error-summary">
      <div role="alert">
        <h2 class="govuk-error-summary__title">
          There is a problem
        </h2>
        <div class="govuk-error-summary__body">
          <ul class="govuk-list govuk-error-summary__list">
            <li>
              <a href="#full-name">Enter your full name</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <input class="govuk-input govuk-input--error" id="full-name-input" name="name" type="text" aria-describedby="full-name-input-error" autocomplete="name">'
    }

    it "should fail" do
      expect {
        expect(html).to summarise_errors([
          "Enter your full name"
        ])
      }.to fail_with("Error message ‘Enter your full name’ links to #full-name but no input field has this ID or name")
    end
  end
end
