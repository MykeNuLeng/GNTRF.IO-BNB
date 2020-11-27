require 'capybara/rspec'
require 'space'
require 'user'
require_relative '../feature_spec_helper'


feature "Add Availability" do
  scenario "accessible by clicking button in profile spaces (when logged in)" do
    space = create_landlord_with_space_and_login
    click_button('PROFILE')
    click_link('Spaces')
    expect(current_path).to eq('/profile/spaces')
    click_button("ADD AVAILABILITY")
    expect(current_path).to eq("/spaces/#{space.space_id}/add-availability")
  end

  scenario "contains two date input elements" do
    space = create_landlord_with_space_and_login
    click_button('PROFILE')
    click_link('Spaces')
    expect(current_path).to eq('/profile/spaces')
    click_button("ADD AVAILABILITY")
    expect(current_path).to eq("/spaces/#{space.space_id}/add-availability")
    expect(page).to have_field('start-date')
    expect(page).to have_field('end-date')
  end
end
