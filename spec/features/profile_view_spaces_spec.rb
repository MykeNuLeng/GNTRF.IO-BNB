require 'capybara/rspec'
require 'order'
require_relative '../feature_spec_helper'

feature "Spaces page" do
  scenario "the route exists" do
    create_account_and_login
    visit('/profile/spaces')
    expect(page.status_code).to eq(200)
  end

  scenario "accessible by clicking link in profile (when logged in)" do
    create_account_and_login
    visit('/profile')
    click_link('Spaces')
    expect(current_path).to eq('/profile/spaces')
  end

  scenario "accessible by clicking button in lettings (when logged in)" do
    create_account_and_login
    visit('/profile/spaces')
    click_button('PROFILE')
    click_link('Spaces')
    expect(current_path).to eq('/profile/spaces')
  end
end
