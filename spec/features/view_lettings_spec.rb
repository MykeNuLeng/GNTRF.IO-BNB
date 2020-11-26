require_relative '../feature_spec_helper'
require 'capybara/rspec'

feature "List of lettings" do
  scenario "it contains appropriate elements" do
    create_account_and_login
    visit('/profile/lettings')
    expect(page).to have_css '.logo'
    expect(page).to have_button 'PROFILE'
    expect(page).to have_button 'LOG OFF'
    expect(page).to have_button 'NEW LISTING'
    expect(page).to have_link 'Bookings'
    expect(page).to have_content 'Lettings'
    expect(page).not_to have_link 'Lettings'
    expect(page).to have_link 'Spaces'
    expect(page).to have_content 'MY LETTINGS'
    expect(page).to have_content 'No lettings to show yet!'
  end
end