require 'capybara/rspec'
require_relative '../feature_spec_helper'

feature "Profile page" do
  scenario "the route exists" do
    visit('/profile')
    expect(page.status_code).to eq(200)
  end

  scenario "accessible by clicking button in spaces (when logged in)" do
    create_account_and_login
    visit('/spaces')
    click_button('PROFILE')
    expect(current_path).to eq('/profile')
  end

  scenario "accessible by clicking button in new spaces (when logged in)" do
    create_account_and_login
    visit('/spaces/new')
    click_button('PROFILE')
    expect(current_path).to eq('/profile')
  end
end