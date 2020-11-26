require 'capybara/rspec'
require 'order'
require_relative '../feature_spec_helper'

feature "Profile page" do
  scenario "the route exists" do
    create_account_and_login
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
    visit('/profile')
    expect(page).to have_css '.logo'
    expect(page).to have_button 'PROFILE'
    expect(page).to have_button 'LOG OFF'
    expect(page).to have_button 'NEW LISTING'
    expect(page).not_to have_link 'Bookings'
    expect(page).to have_content 'Bookings'
    expect(page).to have_link 'Lettings'
    expect(page).to have_link 'Spaces'
    expect(page).to have_content 'MY BOOKINGS'
    expect(page).to have_content 'No bookings to show yet!'
  end

  scenario "displays a booking correctly" do
    user = User.create(email: "test@test.com", username: "brian", password: "Testlength123")
    space = Space.create(
      user_id: user.user_id,
      price: 6900,
      headline: "Amazing space",
      description: "test")
    Order.create(
      space_id: space.space_id,
      user_id: user.user_id,
      booking_start: "2021-04-19",
      booking_end: "2021-04-21"
    )
    visit('/')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'Testlength123')
    click_button('LOGIN')
    click_button('PROFILE')
    expect(page).to have_content("Amazing space")
    expect(page).to have_content("UNCONFIRMED")
    expect(page).to have_button("VIEW")
    expect(page).to have_content("19/04/21 - 21/04/21")
  end

  scenario "user can change to lettings page" do
    create_account_and_login
    click_button('PROFILE')
    click_link('Lettings')
    expect(current_path).to eq('/profile/lettings')
  end
end
