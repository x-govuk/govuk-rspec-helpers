# frozen_string_literal: true
require "spec_helper"

RSpec.describe "click_govuk_link", type: :feature do

  context "where there are no links" do
    before do
      TestApp.body = '<div>Testing</div>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('Testing')
      }.to raise_error('Unable to find link "Testing"')
    end
  end

  context "where the href is given instead of the link text" do
    before do
      TestApp.body = '<a href="/success" class="govuk-link">Testing</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('/success')
      }.to raise_error('Use the full link text within click_govuk_link() instead of the link href')
    end
  end

  context "where the id is given instead of the link text" do
    before do
      TestApp.body = '<a id="success" href="/success" class="govuk-link">Testing</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('success')
      }.to raise_error('Use the full link text within click_govuk_link() instead of the link id')
    end
  end

  context "where a link contains the govuk-link class" do
    before do
      TestApp.body = '<a href="/success" class="govuk-link">Testing</a>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Testing')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link contains the govuk-link class and a modifier class" do
    before do
      TestApp.body = '<a href="/success" class=" govuk-link  app-link--orange">Testing</a>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Testing')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link contains the govuk-breadcrumbs__link class" do
    before do
      TestApp.body = '<div class="govuk-breadcrumbs"><ol class="govuk-breadcrumbs__list"><li class="govuk-breadcrumbs__list-item"><a href="/success" class="govuk-breadcrumbs__link">Testing</a></li></ol></div>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Testing')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link contains the govuk-back-link class" do
    before do
      TestApp.body = '<a href="/success" class="govuk-back-link">Back</a>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Back')
      expect(page.current_path).to eql("/success")
    end
  end


  context "where a link contains the govuk-header__link class" do
    before do
      TestApp.body = '<a href="/success" class="govuk-header__link">Apply for help</a>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Apply for help')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link contains the govuk-footer__link class" do
    before do
      TestApp.body = '<a href="/success" class="govuk-footer__link">Privacy policy</a>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Privacy policy')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link contains the govuk-notification-banner__link class" do
    before do
      TestApp.body = '<div class="govuk-notification-banner__content"><p class="govuk-notification-banner__heading">
      You have 7 days left to send your application.
      <a class="govuk-notification-banner__link" href="/success">View application</a>.</p></div>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('View application')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link contains the govuk-skip-link class" do
    before do
      TestApp.body = '<a href="/success" class="govuk-skip-link" data-module="govuk-skip-link">Skip to main content</a>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Skip to main content')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link contains the govuk-tabs__tab class" do
    before do
      TestApp.body = '<ul class="govuk-tabs__list"><li class="govuk-tabs__list-item govuk-tabs__list-item--selected">
      <a class="govuk-tabs__tab" href="/success">Yesterday</a>
    </li></ul>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Yesterday')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where a link matches the text but doesn’t contain any classes" do
    before do
      TestApp.body = '<a href="/success">Testing</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('Testing')
      }.to raise_error('"Testing" link is missing a class, should contain "govuk-link"')
    end
  end

  context "where a link matches the text but doesn’t contain any recognised classes" do
    before do
      TestApp.body = '<a href="/success" class="app-link-blue">Testing</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('Testing')
      }.to raise_error('"Testing" link is missing a govuk-link class, contains app-link-blue')
    end
  end

  context "where a link contains visually-hidden text" do
    before do
      TestApp.body = '<a href="/success" class="govuk-link">Change<span class="govuk-visually-hidden"> date of birth</span></a>'
      visit('/')
    end

    it 'should raise an error if the visually-hidden text isn’t included' do
      expect {
        click_govuk_link('Change')
      }.to raise_error('Unable to find link "Change" but did find link with the text "Change date of birth" - include the full link text including any visually-hidden text')
    end
  end

  context "where there are multiple links with the same text" do
    before do
      TestApp.body = '<p><a href="/fail1" class="govuk-link">Testing</a></p><a href="/fail2" class="govuk-link">Testing</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('Testing')
      }.to raise_error('There are 2 links with the link text "Testing" - links should be unique within a page')
    end
  end

  context "where there is a link but the link text is not descriptive" do
    before do
      TestApp.body = '<p><a href="/success" class="govuk-link">Change</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('Change')
      }.to raise_error('The link was found, but the text "Change" is ambiguous if heard out of context - add some visually-hidden text')
    end
  end

  context "where the link is styled as a button" do
    before do
      TestApp.body = '<p><a href="/success" class="govuk-button" role="button" data-module="govuk-button">Continue</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('Continue')
      }.to raise_error('The link was found, but is styled as a button. Use `click_govuk_button` instead.')
    end
  end

  context "where the link is set to open in a new tab and mention this in link text" do
    before do
      TestApp.body = '<p><a href="/success" class="govuk-link" target="_blank">Guidance<span class="govuk-visually-hidden"> (opens in new tab)</span></a>'
      visit('/')
    end

    it 'should take user to the linked page' do
      click_govuk_link('Guidance (opens in new tab)')
      expect(page.current_path).to eql("/success")
    end
  end

  context "where the link is set to open in a new tab but doesn’t mention this" do
    before do
      TestApp.body = '<p><a href="/success" class="govuk-link" target="_blank">Guidance</a>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        click_govuk_link('Guidance')
      }.to raise_error('The link was found, but is set to open in a new tab. Either remove this, or add "(opens in new tab)" to the link text')
    end
  end
end
