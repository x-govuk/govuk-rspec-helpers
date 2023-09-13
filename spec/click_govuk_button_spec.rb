# frozen_string_literal: true
require "spec_helper"

RSpec.describe "click_govuk_button", type: :feature do

  context "where there no button" do
    before do
      TestApp.body = ''
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Testing')
      }.to raise_error('Unable to find button "Testing"')
    end
  end

  context "where there is a button" do
    before do
      TestApp.body = '<form action="/success" method="post"><button class="govuk-button" data-module="govuk-button">
      Continue
      </button></form>'
      visit('/')
    end

    it 'should submit the form' do
      click_govuk_button('Continue')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where there are 2 buttons with the same text" do
    before do
      TestApp.body = '<button>Continue</button> <button>Continue</button>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Continue')
      }.to raise_error('There are 2 buttons with the text "Continue" - buttons should be unique within a page')
    end
  end

  context "where the button is missing a class" do
    before do
      TestApp.body = '<form action="/success" method="post"><button data-module="govuk-button">
      Continue
      </button></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Continue')
      }.to raise_error('Button is missing a class, should contain "govuk-button"')
    end
  end

  context "where the button has classes but not a govuk-button class" do
    before do
      TestApp.body = '<form action="/success" method="post"><button class="btn btn-bold" data-module="govuk-button">
      Continue
      </button></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Continue')
      }.to raise_error('Button is missing the govuk-button class, contains btn, btn-bold')
    end
  end

  context "where the button has the govuk-button class but not data-module=govuk-button" do
    before do
      TestApp.body = '<form action="/success" method="post"><button class="govuk-button">
      Continue
      </button></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Continue')
      }.to raise_error('Button is missing the data-module="govuk-button" attribute')
    end
  end

  context "where a start button has all the right attributes" do
    before do
      TestApp.body = '<a href="/success" role="button" draggable="false" class="govuk-button govuk-button--start" data-module="govuk-button">
  Start now
  <svg class="govuk-button__start-icon" xmlns="http://www.w3.org/2000/svg" width="17.5" height="19" viewBox="0 0 33 40" aria-hidden="true" focusable="false">
    <path fill="currentColor" d="M0 0h13l20 20-20 20H0l20-20z" />
  </svg></a> '
      visit('/')
    end

    it 'should follow the link' do
      click_govuk_button('Start now')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link is styled as a button but role=button is missing" do
    before do
      TestApp.body = '<a href="/success" class="govuk-button" data-module="govuk-button">Continue</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Continue')
      }.to raise_error('Button found, but `role="button"` is missing, this is needed on links styled as buttons')
    end
  end

  context "where a link is styled as a button but draggable=false is missing" do
    before do
      TestApp.body = '<a href="/success" class="govuk-button" data-module="govuk-button" role="button">Continue</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Continue')
      }.to raise_error('Button found, but `draggable="false"` is missing, this is needed on links styled as buttons')
    end
  end

  context "where the button contains visually-hidden text, but this isn’t specified in the helper" do
    before do
      TestApp.body = '<form action="/success" method="post"><button class="govuk-button" data-module="govuk-button">
      Add <span class="govuk-visually-hidden">test</span>
      </button></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Add')
      }.to raise_error('Unable to find button "Add" but did find button with the text "Add test" - include the full button text including any visually-hidden text')
    end
  end

  context "where the button is disabled" do
    before do
      TestApp.body = '<form action="/success" method="post"><button disabled="disabled" aria-disabled="true" class="govuk-button govuk-button--disabled" data-module="govuk-button">
        Submit
      </button></form>'
      visit('/')
    end

    context "and disabled wasn’t specified" do
      it 'should raise an error' do
        expect {
          click_govuk_button('Submit')
        }.to raise_error('Button is disabled. Avoid using disabled buttons as they have poor contrast and can confuse users. If this is unavoidable, use click_govuk_button("Submit", disabled: true)')
      end
    end

    context "and disabled was specified" do
      it 'should not follow the link' do
        click_govuk_button('Submit', disabled: true)
        expect(page.current_path).to eql("/")
      end
    end
  end

  context "where the button is disabled but the modifier class is missing" do
    before do
      TestApp.body = '<form action="/success" method="post"><button disabled="disabled" aria-disabled="true" class="govuk-button" data-module="govuk-button">
        Submit
      </button></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Submit', disabled: true)
      }.to raise_error('Disabled button is missing the govuk-button--disabled class')
    end
  end

  context "where the button is disabled but aria-disabled is missing" do
    before do
      TestApp.body = '<form action="/success" method="post"><button disabled="disabled" class="govuk-button govuk-button--disabled" data-module="govuk-button">
        Submit
      </button></form>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_button('Submit', disabled: true)
      }.to raise_error('Disabled button is missing aria-disabled="true"')
    end
  end
end
