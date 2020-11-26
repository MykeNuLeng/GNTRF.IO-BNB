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

  scenario "it displays lettings" do
    tenant = User.create(email: "test@test.com", username: "brian", password: "Testlength123")
    landlord = User.create(email: "leech@test.com", username: "parasite", password: "Testlength123")

    space = Space.create(
      user_id: landlord.user_id,
      price: 6900,
      headline: "Amazing space",
      description: "test"
    )
    Order.create(
      space_id: space.space_id,
      user_id: tenant.user_id,
      booking_start: "2021-04-19",
      booking_end: "2021-04-21"
    )
    visit('/')
    fill_in('email', with: 'leech@test.com')
    fill_in('password', with: 'Testlength123')
    click_button('LOGIN')
    click_button('PROFILE')
    click_link('Lettings')
    expect(page).to have_content(space.headline)
    expect(page).to have_content("19/04/21 - 21/04/21")
    expect(page).to have_button("CONFIRM")
    expect(page).to have_button("REJECT")
  end
end