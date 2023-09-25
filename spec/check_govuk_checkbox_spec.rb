# frozen_string_literal: true
require "spec_helper"

RSpec.describe "checking a chekcbox", type: :feature do

  context "where there are multiple checkboxes nested in a fieldset" do

    before do
       TestApp.body = '<div class="govuk-form-group">
  <fieldset class="govuk-fieldset" aria-describedby="waste-hint">
    <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
      <h1 class="govuk-fieldset__heading">
        Which types of waste do you transport?
      </h1>
    </legend>
    <div id="waste-hint" class="govuk-hint">
      Select all that apply.
    </div>
    <div class="govuk-checkboxes" data-module="govuk-checkboxes">
      <div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="waste" name="waste" type="checkbox" value="carcasses">
        <label class="govuk-label govuk-checkboxes__label" for="waste">
          Waste from animal carcasses
        </label>
      </div>
      <div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="waste-2" name="waste" type="checkbox" value="mines">
        <label class="govuk-label govuk-checkboxes__label" for="waste-2">
          Waste from mines or quarries
        </label>
      </div>
      <div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="waste-3" name="waste" type="checkbox" value="farm">
        <label class="govuk-label govuk-checkboxes__label" for="waste-3">
          Farm or agricultural waste
        </label>
      </div>
    </div>
  </fieldset>
</div>'
      visit('/')
    end

    context "and the full fieldset and label is specified" do
      it 'should be successful' do
        within_govuk_fieldset "Which types of waste do you transport?" do
          check_govuk_checkbox "Waste from mines or quarries"
        end

        expect(page).to have_checked_field("Waste from mines or quarries")
      end
    end

    context "and the input id is specified" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "Which types of waste do you transport?" do
            check_govuk_checkbox "waste-2"
          end
        }.to raise_error('Use the full label text "Waste from mines or quarries" instead of the input ID')
      end
    end

    context "and no matching label can be found" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "Which types of waste do you transport?" do
          check_govuk_checkbox "Waste from household bins"
          end
        }.to raise_error('Unable to find label with the text "Waste from household bins"')
      end
    end


  end

  context "where the checkbox has an associated hint" do
    before do
      TestApp.body = '<div class="govuk-form-group">
  <fieldset class="govuk-fieldset" aria-describedby="nationality-hint">
    <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
      <h1 class="govuk-fieldset__heading">
        What is your nationality?
      </h1>
    </legend>
    <div id="nationality-hint" class="govuk-hint">
      If you have dual nationality, select all options that are relevant to you.
    </div>
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
</div>'
      visit '/'
    end

    context "and hint is not specified" do
      it 'should be successful' do
        within_govuk_fieldset "What is your nationality?" do
          check_govuk_checkbox "British"
        end

        expect(page).to have_checked_field("British")
      end
    end

    context "and the full label and hint are specified" do
      it 'should be successful' do
        within_govuk_fieldset "What is your nationality?" do
          check_govuk_checkbox "British", hint: "including English, Scottish, Welsh and Northern Irish"
        end

        expect(page).to have_checked_field("British")
      end
    end

    context "and the hint does not match" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "What is your nationality?" do
            check_govuk_checkbox "British", hint: "or citizen of United Kingdom"
          end
        }.to raise_error('Found checkbox but could not find matching hint. Found the hint "including English, Scottish, Welsh and Northern Irish" instead')
      end
    end

    context "and both the label and hint do not match" do
      it 'should raise an error focused on the label' do
        expect {
          within_govuk_fieldset "What is your nationality?" do
            check_govuk_checkbox "United Kingdom", hint: "or British"
          end
        }.to raise_error('Unable to find label with the text "United Kingdom"')
      end
    end

  end

  context "where the label has a 'for' attribute but no input matches" do
    before do
       TestApp.body = '
      <div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="organisation-1" name="organisation" type="checkbox" value="DfT">
        <label class="govuk-label govuk-checkboxes__label" for="organisation-2">
          Department for Transport
        </label>
      </div>'
      visit('/')
    end

    it "should raise an error" do
      expect {
        check_govuk_checkbox "Department for Transport"
      }.to raise_error('Found the label but it is not associated with an checkbox, did not find a checkbox with the ID "organisation-2".')
    end
  end

  context "where the label is missing a 'for' attribute" do
    before do
       TestApp.body = '
      <div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="organisation-1" name="organisation" type="checkbox" value="DfT">
        <label class="govuk-label govuk-checkboxes__label">
          Department for Transport
        </label>
      </div>'
      visit('/')
    end

    it "should raise an error" do
      expect {
        check_govuk_checkbox "Department for Transport"
      }.to raise_error('Found the label but it is not associated with an checkbox, was missing a for="" attribute')
    end
  end

  context "where the hint has no ID and is not associated with the input" do
    before do
      TestApp.body = '<div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="nationality" name="nationality" type="checkbox" value="british">
        <label class="govuk-label govuk-checkboxes__label" for="nationality">
          British
        </label>
        <div class="govuk-hint govuk-checkboxes__hint">
          including English, Scottish, Welsh and Northern Irish
        </div>
      </div>'
      visit '/'
    end

    context 'and the hint is specified' do
      it "should raise an error" do
        expect {
          check_govuk_checkbox "British", hint: "including English, Scottish, Welsh and Northern Irish"
        }.to raise_error('Found checkbox and hint, but the hint is not associated with the input using aria. And an ID to the hint and Add aria-describedby= to the input with that ID.')
      end
    end

    context 'and the hint is not specified' do
      it "should still raise an error" do
        expect {
          check_govuk_checkbox "British"
        }.to raise_error('Found checkbox, but also found a hint that is not associated with the input using aria. And an ID to the hint and Add aria-describedby= to the input with that ID.')
      end
    end
  end

  context "where the hint has an ID but is not associated with the input" do
    before do
      TestApp.body = '<div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="nationality" name="nationality" type="checkbox" value="british">
        <label class="govuk-label govuk-checkboxes__label" for="nationality">
          British
        </label>
        <div id="nationality-item-hint" class="govuk-hint govuk-checkboxes__hint">
          including English, Scottish, Welsh and Northern Irish
        </div>
      </div>'
      visit '/'
    end

    context 'and the hint is specified' do
      it "should raise an error" do
        expect {
          check_govuk_checkbox "British", hint: "including English, Scottish, Welsh and Northern Irish"
        }.to raise_error('Found checkbox and hint, but the hint is not associated with the input using aria. Add aria-describedby="nationality-item-hint" to the input.')
      end
    end

    context 'and the hint is not specified' do
      it "should still raise an error" do
        expect {
          check_govuk_checkbox "British"
        }.to raise_error('Found checkbox, but also found a hint that is not associated with the input using aria. Add aria-describedby="nationality-item-hint" to the input.')
      end
    end
  end

  context "where the label is missing both classes" do
    before do
       TestApp.body = '
        <input id="waste-3" name="waste" type="checkbox" value="farm">
        <label for="waste-3">
          Farm or agricultural waste
        </label>
        '
      visit('/')
    end

    context "and the label text is specified" do
      it "should raise an error" do
        expect {
          check_govuk_checkbox "Farm or agricultural waste"
        }.to raise_error('Found label but it is missing the govuk-label and govuk-checkboxes__label classes')
      end
    end
  end

  context "where the label is missing the govuk-checkboxes__label class" do
    before do
       TestApp.body = '
        <input id="waste-3" name="waste" type="checkbox" value="farm">
        <label for="waste-3" class="govuk-label ">
          Farm or agricultural waste
        </label>
        '
      visit('/')
    end

    context "and the label text is specified" do
      it "should raise an error" do
        expect {
          check_govuk_checkbox "Farm or agricultural waste"
        }.to raise_error('Found label but it is missing the govuk-checkboxes__label class')
      end
    end
  end

  context "where the input is missing the govuk-checkboxes__input class" do
    before do
       TestApp.body = '
        <input id="waste-3" name="waste" type="checkbox" value="farm">
        <label for="waste-3" class="govuk-label govuk-checkboxes__label">
          Farm or agricultural waste
        </label>
        '
      visit('/')
    end

    context "and the label text is specified" do
      it "should raise an error" do
        expect {
          check_govuk_checkbox "Farm or agricultural waste"
        }.to raise_error('Found checkbox but it is missing the govuk-checkboxes__input class')
      end
    end

  end

  context "where there are 2 labels with the same text" do
    before do
       TestApp.body = '
      <div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="organisation-1" name="organisation" type="checkbox" value="DfT">
        <label class="govuk-label govuk-checkboxes__label" for="organisation-1">
          Department for Transport
        </label>
      </div>
      <div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="organisation-2" name="organisation" type="checkbox" value="DfT2">
        <label class="govuk-label govuk-checkboxes__label" for="organisation-2">
          Department for Transport
        </label>
      </div>
        '
      visit('/')
    end

    it "should raise an error" do
      expect {
        check_govuk_checkbox "Department for Transport"
      }.to raise_error('Found 2 labels with the same text. Checkbox labels should be unique within a fieldset.')
    end

  end

  context "where the input is a radio instead" do
    before do
       TestApp.body = '<div class="govuk-checkboxes__item">
        <input class="govuk-radios__input" id="whereDoYouLive" name="whereDoYouLive" type="radio" value="england">
        <label class="govuk-label govuk-checkboxes__label" for="whereDoYouLive">
          England
        </label>
      </div>'
      visit('/')
    end

    it "should raise an error" do
      expect {
        check_govuk_checkbox "England"
      }.to raise_error('Found the label, but it is associated with an input with type="radio" not a checkbox')
    end

  end

  context "where there are 2 elements with a matching ID" do
    before do
       TestApp.body = '<div class="govuk-checkboxes__item" id="whereDoYouLive">
        <input class="govuk-checkboxes__input" id="whereDoYouLive" name="whereDoYouLive" type="checkbox" value="england">
        <label class="govuk-label govuk-checkboxes__label" for="whereDoYouLive">
          England
        </label>
      </div>'
      visit('/')
    end

    it "should raise an error" do
      expect {
        check_govuk_checkbox "England"
      }.to raise_error('Found 2 elements with id="whereDoYouLive". IDs must be unique.')
    end
  end

  context "where the checkbox is already checked" do
    before do
       TestApp.body = '<div class="govuk-checkboxes__item">
        <input class="govuk-checkboxes__input" id="whereDoYouLive" name="whereDoYouLive" type="checkbox" value="england" checked>
        <label class="govuk-label govuk-checkboxes__label" for="whereDoYouLive">
          England
        </label>
      </div>'
      visit('/')
    end

    it "should raise an error" do
      expect {
        check_govuk_checkbox "England"
      }.to raise_error('Found checkbox, but it was already checked')
    end
  end

end
