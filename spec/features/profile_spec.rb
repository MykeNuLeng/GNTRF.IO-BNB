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

  scenario "has all the correct elements when logged in" do
    create_account_and_login
    visit('/spaces')
    expect(page).to have_css '.logo'
    expect(page).to have_button 'PROFILE'
    expect(page).to have_button 'LOG OFF'
    expect(page).to have_button 'NEW LISTING'
    expect(page).not_to have_link 'Bookings'
    expect(page).to have_link 'Spaces'
    expect(page).to have_content 'MY BOOKINGS'
    expect(page).to have_content 'No bookings to show yet!'
  end
end