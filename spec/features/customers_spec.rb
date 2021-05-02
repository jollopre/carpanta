require_relative "shared_context"

RSpec.describe "Customers resource", type: :feature do
  include_context "features"

  let(:name) { "Donald" }
  let(:surname) { "Duck" }
  let(:email) { "donald.duck@carpanta.com" }

  it "creates a customer" do
    visit "/customers/new"

    page.fill_in "customer[name]", with: name
    page.fill_in "customer[surname]", with: surname
    page.fill_in "customer[email]", with: email

    click_button "Create"

    expect(page).to have_text(name)
    expect(page).to have_text(surname)
    expect(page).to have_text(email)
  end
end
