# frozen_string_literal: true
require "spec_helper"

RSpec.describe "within a govuk fieldset", type: :feature do

  context "where there are 2 fieldsets with the same options that differ by legend" do

    before do
      TestApp.body = '<form action="/success" method="post">
<div class="govuk-form-group">
  <fieldset class="govuk-fieldset" id="whereDoYouLiveFieldset">
    <legend class="govuk-fieldset__legend">
      Where do you live?
    </legend>
    <div class="govuk-radios" data-module="govuk-radios">
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="whereDoYouLive" name="whereDoYouLive" type="radio" value="england">
        <label class="govuk-label govuk-radios__label" for="whereDoYouLive">
          England
        </label>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="whereDoYouLive-2" name="whereDoYouLive" type="radio" value="scotland">
        <label class="govuk-label govuk-radios__label" for="whereDoYouLive-2">
          Scotland
        </label>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="whereDoYouLive-3" name="whereDoYouLive" type="radio" value="wales">
        <label class="govuk-label govuk-radios__label" for="whereDoYouLive-3">
          Wales
        </label>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="whereDoYouLive-4" name="whereDoYouLive" type="radio" value="northern-ireland">
        <label class="govuk-label govuk-radios__label" for="whereDoYouLive-4">
          Northern Ireland
        </label>
      </div>
    </div>
  </fieldset>
</div>
<div class="govuk-form-group">
  <fieldset class="govuk-fieldset" id="whereDoYouWantToLiveFieldset">
    <legend class="govuk-fieldset__legend">
      Where do you want to live?
    </legend>
    <div class="govuk-radios" data-module="govuk-radios">
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="whereDoYouWantToLive" name="whereDoYouWantToLive" type="radio" value="england">
        <label class="govuk-label govuk-radios__label" for="whereDoYouWantToLive">
          England
        </label>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="whereDoYouWantToLive-2" name="whereDoYouWantToLive" type="radio" value="scotland">
        <label class="govuk-label govuk-radios__label" for="whereDoYouWantToLive-2">
          Scotland
        </label>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="whereDoYouWantToLive-3" name="whereDoYouWantToLive" type="radio" value="wales">
        <label class="govuk-label govuk-radios__label" for="whereDoYouWantToLive-3">
          Wales
        </label>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="whereDoYouWantToLive-4" name="whereDoYouWantToLive" type="radio" value="northern-ireland">
        <label class="govuk-label govuk-radios__label" for="whereDoYouWantToLive-4">
          Northern Ireland
        </label>
      </div>
    </div>
  </fieldset>
</div>
</form>'
      visit('/')
    end

    context "and the right fieldset legend is specified" do
      it 'should should select the field' do
        within_govuk_fieldset "Where do you want to live?" do
          choose "whereDoYouWantToLive-3"
        end

        expect(page).to have_checked_field("whereDoYouWantToLive-3")
      end
    end

    context "and the wrong fieldset legend is specified" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "Where do you live?" do
            choose "whereDoYouWantToLive-3"
          end
        }.to raise_error(Capybara::ElementNotFound)
      end
    end

    context "and fieldset ID is used" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "whereDoYouWantToLiveFieldset" do
            choose "Wales"
          end
        }.to raise_error('Use the full legend text "Where do you want to live?" instead of the fieldset ID')
      end
    end
  end

  context "where there is no fieldset" do
    before do
      TestApp.body = '<form action="/success" method="post"></form>'
    end

    it 'should raise an error' do
      expect {
        within_govuk_fieldset "Where do you live?" do
        end
      }.to raise_error("No fieldset found with matching legend")
    end
  end

  context "where the fieldset has a hint" do
    before do
      TestApp.body = '<div class="govuk-form-group">
  <fieldset class="govuk-fieldset" aria-describedby="changedName-hint">
    <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
      <h1 class="govuk-fieldset__heading">
        Have you changed your name?
      </h1>
    </legend>
    <div id="changedName-hint" class="govuk-hint">
      This includes changing your last name or spelling your name differently.
    </div>
    <div class="govuk-radios govuk-radios--inline" data-module="govuk-radios">
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="changedName" name="changedName" type="radio" value="yes">
        <label class="govuk-label govuk-radios__label" for="changedName">
          Yes
        </label>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="changedName-2" name="changedName" type="radio" value="no">
        <label class="govuk-label govuk-radios__label" for="changedName-2">
          No
        </label>
      </div>
    </div>
  </fieldset>
</div>'
      visit('/')
    end

    context "and the fieldset legend and hint are specified" do
      it 'should select the field' do
        within_govuk_fieldset "Have you changed your name?",
          hint: "This includes changing your last name or spelling your name differently." do
          choose "Yes"
        end

        expect(page).to have_checked_field("Yes")
      end
    end

    context "and the hint does not match" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "Have you changed your name?",
            hint: "For example, through a deed poll or marriage certificate" do
            choose "Yes"
          end
        }.to raise_error("Count not find hint with that text")
      end
    end
  end


  context "where the fieldset is not associated with the hint using aria-describedby" do
    before do
      TestApp.body = '<div class="govuk-form-group">
  <fieldset class="govuk-fieldset">
    <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
      <h1 class="govuk-fieldset__heading">
        Have you changed your name?
      </h1>
    </legend>
    <div class="govuk-hint">
      This includes changing your last name or spelling your name differently.
    </div>
    <div class="govuk-radios govuk-radios--inline" data-module="govuk-radios">
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="changedName" name="changedName" type="radio" value="yes">
        <label class="govuk-label govuk-radios__label" for="changedName">
          Yes
        </label>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="changedName-2" name="changedName" type="radio" value="no">
        <label class="govuk-label govuk-radios__label" for="changedName-2">
          No
        </label>
      </div>
    </div>
  </fieldset>
</div>'
      visit('/')
    end

    it 'should select the field' do
      expect {
        within_govuk_fieldset "Have you changed your name?",
          hint: "This includes changing your last name or spelling your name differently." do
          choose "Yes"
        end
      }.to raise_error("Found hint but it is not associated with the fieldset using aria-describedby")

    end
  end

end
