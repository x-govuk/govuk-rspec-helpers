# frozen_string_literal: true
require "spec_helper"

RSpec.describe "choosing a radio button", type: :feature do

  context "where the options are in a fieldset and associated with a label" do

    before do
      TestApp.body = '<form action="/success" method="post">
<div class="govuk-form-group">
  <fieldset class="govuk-fieldset">
    <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
      <h1 class="govuk-fieldset__heading">
        Where do you live?
      </h1>
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
</form>'
      visit('/')
    end

    context "and the full fieldset and label is specified" do
      it 'should be successful' do
        within_govuk_fieldset "Where do you live?" do
          choose_govuk_radio "Wales"
        end

        expect(page).to have_checked_field("Wales")
      end
    end

    context "and the input ID is specified" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "Where do you live?" do
            choose_govuk_radio "whereDoYouLive-3"
          end
        }.to raise_error('Use the full label text "Wales" instead of the input ID')
      end
    end

    context "and no matching label can be found" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "Where do you live?" do
            choose_govuk_radio "France"
          end
        }.to raise_error('Unable to find label with the text "France"')
      end
    end

  end
end
