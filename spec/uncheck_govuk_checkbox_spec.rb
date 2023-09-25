# frozen_string_literal: true
require "spec_helper"

RSpec.describe "unchecking a chekcbox", type: :feature do

  context "where a checkbox is already checked" do
    before do
       TestApp.body = '<div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="waste-2" name="waste" type="checkbox" value="mines" checked>
        <label class="govuk-label govuk-checkboxes__label" for="waste-2">
          Waste from mines or quarries
        </label>
      </div>'
      visit('/')
    end

    it 'should be successful' do
      uncheck_govuk_checkbox "Waste from mines or quarries"

      expect(page).to have_unchecked_field("Waste from mines or quarries")
    end
  end

  context "where a checkbox is was not previously checked" do
    before do
       TestApp.body = '<div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="waste-2" name="waste" type="checkbox" value="mines">
        <label class="govuk-label govuk-checkboxes__label" for="waste-2">
          Waste from mines or quarries
        </label>
      </div>'
      visit('/')
    end

    it 'should raise an error' do
      expect {
        uncheck_govuk_checkbox "Waste from mines or quarries"
      }.to raise_error("Found checkbox, but it was already unchecked")
    end
  end

end
