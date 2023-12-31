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

  context "where the options each have an associated hint" do
    before do
      TestApp.body = '<form action="/success" method="post">
<div class="govuk-form-group">
  <fieldset class="govuk-fieldset">
    <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
      <h1 class="govuk-fieldset__heading">
        How do you want to sign in?
      </h1>
    </legend>
    <div class="govuk-radios" data-module="govuk-radios">
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="signIn" name="signIn" type="radio" value="government-gateway" aria-describedby="signIn-item-hint">
        <label class="govuk-label govuk-radios__label" for="signIn">
          Sign in with Government Gateway
        </label>
        <div id="signIn-item-hint" class="govuk-hint govuk-radios__hint">
          You’ll have a user ID if you’ve registered for Self Assessment or filed a tax return online before.
        </div>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="signIn-2" name="signIn" type="radio" value="govuk-one-login" aria-describedby="signIn-2-item-hint">
        <label class="govuk-label govuk-radios__label" for="signIn-2">
          Sign in with GOV.UK One Login
        </label>
        <div id="signIn-2-item-hint" class="govuk-hint govuk-radios__hint">
          If you don’t have a GOV.UK One Login, you can create one.
        </div>
      </div>
    </div>
  </fieldset>
</div>
</form>'
      visit('/')
    end

    context "and just the label is specified" do
      it 'should be successful' do
        within_govuk_fieldset "How do you want to sign in?" do
          choose_govuk_radio "Sign in with GOV.UK One Login"
        end

        expect(page).to have_checked_field("Sign in with GOV.UK One Login")
      end
    end

    context "and the label and hint are specified" do
      it 'should be successful' do
        within_govuk_fieldset "How do you want to sign in?" do
          choose_govuk_radio "Sign in with GOV.UK One Login",
            hint: "If you don’t have a GOV.UK One Login, you can create one."
        end

        expect(page).to have_checked_field("Sign in with GOV.UK One Login")
      end
    end

    context "and the label is specified but the hint doesn’t match" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "How do you want to sign in?" do
            choose_govuk_radio "Sign in with GOV.UK One Login",
              hint: "This is the new way to access government services"
          end
        }.to raise_error('Found radio but could not find matching hint. Found the hint "If you don’t have a GOV.UK One Login, you can create one." instead')
      end
    end
  end

  context "where a hint has an ID but the input isn’t associated with it using aria-describedby" do
    before do
      TestApp.body = '<form action="/success" method="post">
<div class="govuk-form-group">
  <fieldset class="govuk-fieldset">
    <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
      <h1 class="govuk-fieldset__heading">
        How do you want to sign in?
      </h1>
    </legend>
    <div class="govuk-radios" data-module="govuk-radios">
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="signIn" name="signIn" type="radio" value="government-gateway">
        <label class="govuk-label govuk-radios__label" for="signIn">
          Sign in with Government Gateway
        </label>
        <div id="signIn-item-hint" class="govuk-hint govuk-radios__hint">
          You’ll have a user ID if you’ve registered for Self Assessment or filed a tax return online before.
        </div>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="signIn-2" name="signIn" type="radio" value="govuk-one-login">
        <label class="govuk-label govuk-radios__label" for="signIn-2">
          Sign in with GOV.UK One Login
        </label>
        <div id="signIn-2-item-hint" class="govuk-hint govuk-radios__hint">
          If you don’t have a GOV.UK One Login, you can create one.
        </div>
      </div>
    </div>
  </fieldset>
</div>
</form>'
      visit('/')
    end

    context "and the label and hint are specified" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "How do you want to sign in?" do
            choose_govuk_radio "Sign in with GOV.UK One Login",
              hint: "If you don’t have a GOV.UK One Login, you can create one."
          end
        }.to raise_error("Found radio and hint, but the hint is not associated with the input using aria. Add aria-describedby=signIn-2-item-hint to the input.")
      end
    end
  end

  context "where a hint does not have an ID and the input isn’t associated with it using aria-describedby" do
    before do
      TestApp.body = '<form action="/success" method="post">
<div class="govuk-form-group">
  <fieldset class="govuk-fieldset">
    <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
      <h1 class="govuk-fieldset__heading">
        How do you want to sign in?
      </h1>
    </legend>
    <div class="govuk-radios" data-module="govuk-radios">
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="signIn" name="signIn" type="radio" value="government-gateway">
        <label class="govuk-label govuk-radios__label" for="signIn">
          Sign in with Government Gateway
        </label>
        <div class="govuk-hint govuk-radios__hint">
          You’ll have a user ID if you’ve registered for Self Assessment or filed a tax return online before.
        </div>
      </div>
      <div class="govuk-radios__item">
        <input class="govuk-radios__input" id="signIn-2" name="signIn" type="radio" value="govuk-one-login">
        <label class="govuk-label govuk-radios__label" for="signIn-2">
          Sign in with GOV.UK One Login
        </label>
        <div class="govuk-hint govuk-radios__hint">
          If you don’t have a GOV.UK One Login, you can create one.
        </div>
      </div>
    </div>
  </fieldset>
</div>
</form>'
      visit('/')
    end

    context "and the label and hint are specified" do
      it 'should raise an error' do
        expect {
          within_govuk_fieldset "How do you want to sign in?" do
            choose_govuk_radio "Sign in with GOV.UK One Login",
              hint: "If you don’t have a GOV.UK One Login, you can create one."
          end
        }.to raise_error("Found radio and hint, but the hint is not associated with the input using aria. And an ID to the hint and Add aria-describedby= to the input with that ID.")
      end
    end
  end

end
