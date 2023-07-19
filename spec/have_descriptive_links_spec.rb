# frozen_string_literal: true
require "spec_helper"

RSpec.describe "have descriptive links" do

  context "where each link is unique and descriptive" do
    let(:html) { '<div><a class="govuk-link" href="/links">Add link</a> <a class="govuk-link" href="/images">Change<span class="govuk-visually-hidden"> images</span></a></div>'}

    it "should pass" do
      expect(html).to have_descriptive_links
    end
  end

  context "where a link uses 'change' as link text" do
    let(:html) { '<div><a class="govuk-link" href="/change">Change</a></div>'}

    it "should fail" do
      expect {
        expect(html).to have_descriptive_links
      }.to fail_with("The link ‘Change’ is not clear enough out of context. Add extra text to make the link purpose clear. This can be visually-hidden if needed.")
    end
  end

  context "where 2 links uses the same link text" do
    let(:html) { '<div><a class="govuk-link" href="/add">Add item</a> Test <a class="govuk-link" href="/add?from=dashboard">Add item</a></div>'}

    it "should fail" do
      expect {
        expect(html).to have_descriptive_links
      }.to fail_with("There are 2 links with the link text ‘Add item’. Link texts should be unique across a page.")
    end
  end

end
