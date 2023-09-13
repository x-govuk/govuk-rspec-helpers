# frozen_string_literal: true
require "spec_helper"

RSpec.describe "fill_in_govuk_text_field", type: :feature do

  context "where the input is correctly associated with a label" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
  <h1 class="govuk-label-wrapper">
    <label class="govuk-label govuk-label--l" for="event-name">
      What is the name of the event?
    </label>
  </h1>
  <input class="govuk-input" id="event-name" name="eventName" type="text">
</div></form>'
      visit('/')
    end

    context "and the full label is specified" do
      it 'should be successful' do
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
        expect(page.find_field("What is the name of the event?").value).to eql("Design System Day")
      end
    end

    context "and a partial label is specified" do
      it 'should raise an error' do
        expect {
          fill_in_govuk_text_field("What is the name", with: "Design System Day")
        }.to raise_error('Unable to find label with the text "What is the name" but did find label with the text "What is the name of the event?" - use the full label text')
      end
    end

    context "and the name of the input is used" do
      it 'should raise an error' do
        expect {
          fill_in_govuk_text_field("eventName", with: "Design System Day")
        }.to raise_error('Use the full label text "What is the name of the event?" instead of the field name')
      end
    end

    context "and a hint is is specified" do
      it 'should raise an error' do
        expect {
        fill_in_govuk_text_field("What is the name of the event?", hint: "The name you’ll use on promotional material", with: "Design System Day")
        }.to raise_error('Found the field but could not find the hint "The name you’ll use on promotional material"')
      end
    end
  end

  context "where the label is missing a 'for' attribute" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
  <h1 class="govuk-label-wrapper">
    <label class="govuk-label govuk-label--l">
      What is the name of the event?
    </label>
  </h1>
  <input class="govuk-input" id="event-name" name="eventName" type="text">
</div></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
      }.to raise_error('Found the label but it is missing a "for" attribute to associate it with an input')
    end
  end

  context "where the label has an empty 'for' attribute" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
  <h1 class="govuk-label-wrapper">
    <label class="govuk-label govuk-label--l" for=" ">
      What is the name of the event?
    </label>
  </h1>
  <input class="govuk-input" id="event-name" name="eventName" type="text">
</div></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
      }.to raise_error('Found the label but it is missing a "for" attribute to associate it with an input')
    end
  end

  context "where the label has a 'for' attribute but it doesn’t match an input ID" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
  <h1 class="govuk-label-wrapper">
    <label class="govuk-label govuk-label--l" for="event-name">
      What is the name of the event?
    </label>
  </h1>
  <input class="govuk-input" id="field1" name="eventName" type="text">
</div></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
      }.to raise_error('Found the label but there is no field with the ID "event-name" which matches the label‘s "for" attribute')
    end
  end

  context "where the label has a 'for' attribute but there are 2 elements with that ID" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
  <h1 class="govuk-label-wrapper">
    <label class="govuk-label govuk-label--l" for="event-name">
      What is the name of the event?
    </label>
  </h1>
  <input class="govuk-input" id="event-name" name="eventName" type="text">
  <div id="event-name"></div>
</div></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
      }.to raise_error('Found the label but there there are 2 elements with the ID "event-name" which matches the label‘s "for" attribute')
    end
  end

  context "where the label is associated with an element that isn’t a field" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
  <h1 class="govuk-label-wrapper">
    <label class="govuk-label govuk-label--l" for="event-name">
      What is the name of the event?
    </label>
  </h1>
  <div id="event-name"></div>
</div></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
      }.to raise_error('Found the label but but it is associated with a <div> element instead of a form field')
    end
  end

  context "where the input also has a hint associated with it" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
  <h1 class="govuk-label-wrapper">
    <label class="govuk-label govuk-label--l" for="event-name">
      What is the name of the event?
    </label>
  </h1>
  <div id="event-name-hint" class="govuk-hint">
    The name you’ll use on promotional material
  </div>
  <input class="govuk-input" id="event-name" name="eventName" type="text" aria-describedby="event-name-hint">
</div></form>'
      visit('/')
    end

    context "and the label is specified but the hint isn’t" do
      it "should be successful" do
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
        expect(page.find_field("What is the name of the event?").value).to eql("Design System Day")
      end
    end

    context "and the label and the hint are specified" do
      it "should be successful" do
        fill_in_govuk_text_field("What is the name of the event?", hint: "The name you’ll use on promotional material", with: "Design System Day")
        expect(page.find_field("What is the name of the event?").value).to eql("Design System Day")
      end
    end

    context "and a different hint is specified" do
      it "should be raise an error" do
        expect {
          fill_in_govuk_text_field("What is the name of the event?", hint: "Make it a catchy name", with: "Design System Day")
        }.to raise_error('Found the label but the associated hint is "The name you’ll use on promotional material" not "Make it a catchy name"')
      end
    end
  end

  context "where the input is described by a hint which doesn’t exist" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
        <h1 class="govuk-label-wrapper">
          <label class="govuk-label govuk-label--l" for="event-name">
            What is the name of the event?
          </label>
        </h1>
        <div class="govuk-hint">
          The name you’ll use on promotional material
        </div>
        <input class="govuk-input" id="event-name" name="eventName" type="text" aria-describedby="event-name-hint">
      </div></form>'
      visit('/')
    end

    it "should raise an error" do
      expect {
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
      }.to raise_error('Found the field but it has an "aria-describedby=event-name-hint" attribute and no hint with that ID exists')
    end
  end

  context "where the input is described by a hint but 2 elements with that ID exist" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
        <h1 class="govuk-label-wrapper">
          <label class="govuk-label govuk-label--l" for="event-name">
            What is the name of the event?
          </label>
        </h1>
        <div class="govuk-hint" id="event-name-hint">
          The name you’ll use on promotional material
        </div>
        <div class="govuk-hint" id="event-name-hint">
          Keep it short
        </div>
        <input class="govuk-input" id="event-name" name="eventName" type="text" aria-describedby="event-name-hint">
      </div></form>'
      visit('/')
    end

    it "should raise an error" do
      expect {
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
      }.to raise_error('Found the field but it has an "aria-describedby=event-name-hint" attribute and 2 elements with that ID exist')
    end
  end

  context "where the there is a hint but the aria-describeby is missing" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group">
        <h1 class="govuk-label-wrapper">
          <label class="govuk-label govuk-label--l" for="event-name">
            What is the name of the event?
          </label>
        </h1>
        <div class="govuk-hint" id="event-name-hint">
          The name you’ll use on promotional material
        </div>
        <input class="govuk-input" id="event-name" name="eventName" type="text">
      </div></form>'
      visit('/')
    end

    context "and the hint is specified" do
      it "should raise an error" do
        expect {
          fill_in_govuk_text_field("What is the name of the event?", hint: "The name you’ll use on promotional material", with: "Design System Day")
        }.to raise_error('Found the field and the hint, but not field is not associated with the hint using aria-describedby')
      end
    end
  end

  context "where the input is described by a hint and an error message" do
    before do
      TestApp.body = '<form action="/success" method="post"><div class="govuk-form-group govuk-form-group--error">
        <h1 class="govuk-label-wrapper">
          <label class="govuk-label govuk-label--l" for="event-name">
            What is the name of the event?
          </label>
        </h1>
        <div id="event-name-hint" class="govuk-hint">
          The name you’ll use on promotional material
        </div>
        <p id="event-name-error" class="govuk-error-message">
          <span class="govuk-visually-hidden">Error:</span> Enter an event name
        </p>
        <input class="govuk-input govuk-input--error" id="event-name" name="eventName" type="text" aria-describedby=" event-name-hint event-name-error ">
      </div></form>'
      visit('/')
    end

    context "and the just the label is specified" do
      it 'should be successful' do
        fill_in_govuk_text_field("What is the name of the event?", with: "Design System Day")
        expect(page.find_field("What is the name of the event?").value).to eql("Design System Day")
      end
    end

    context "and the the label and hint are specified" do
      it 'should be successful' do
        fill_in_govuk_text_field("What is the name of the event?", hint: "The name you’ll use on promotional material", with: "Design System Day")
        expect(page.find_field("What is the name of the event?").value).to eql("Design System Day")
      end
    end
  end
end
