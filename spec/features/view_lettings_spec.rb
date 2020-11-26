require_relative '../feature_spec_helper'
require 'capybara/rspec'

feature "List of lettings" do
  scenario "it displays a list of empty lettings if there are none" do
    create_account_and_login
    visit('/profile/lettings')
    expect(page).to have_content('No lettings to show yet!')
  end
end