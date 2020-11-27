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
    expect(page).to have_field('start')
    expect(page).to have_field('end')
  end

  scenario "allows submission" do
    space = create_landlord_with_space_and_login
    click_button('PROFILE')
    click_link('Spaces')
    expect(current_path).to eq('/profile/spaces')
    click_button("ADD AVAILABILITY")
    expect(current_path).to eq("/spaces/#{space.space_id}/add-availability")
    fill_in('start', with: '2020/12/25')
    fill_in('end', with: '2020/12/31')
    click_button('Submit')
    expect(current_path).to eq('/profile/spaces')
  end
end
