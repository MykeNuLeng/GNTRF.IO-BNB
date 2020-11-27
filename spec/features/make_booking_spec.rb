require 'capybara/rspec'
require 'space'
require 'user'
require_relative '../feature_spec_helper'

feature "Make booking" do
  scenario "accessible via the spaces page" do
    landlord = User.create(username: "testy", password: "123Password", email: "testymctesterson@test.org")
    space = Space.create(user_id: landlord.user_id, price: 5400, headline: "Kinda alright space", description: "Really cheap, really damp!")
    user = create_account_and_login
    visit('/spaces')
    expect(page).to have_button('BOOK')
    click_button('BOOK')
    expect(current_path).to eq("/spaces/#{space.space_id}/book")
    expect(page.status_code).to eq(200)
  end

  scenario "has the appropriate elements" do
    landlord = User.create(username: "testy", password: "123Password", email: "testymctesterson@test.org")
    space = Space.create(user_id: landlord.user_id, price: 5400, headline: "Kinda alright space", description: "Really cheap, really damp!")
    user = create_account_and_login
    visit('/spaces')
    click_button('BOOK')
    expect(current_path).to eq("/spaces/#{space.space_id}/book")
    expect(page).to have_field('start')
    expect(page).to have_field('end')
    expect(page).to have_button('Submit')
  end

  scenario "lets user book" do
      landlord = User.create(username: "testy", password: "123Password", email: "testymctesterson@test.org")
      space = Space.create(user_id: landlord.user_id, price: 5400, headline: "Kinda alright space", description: "Really cheap, really damp!")
      user = create_account_and_login
      visit('/spaces')
      click_button('BOOK')
      expect(current_path).to eq("/spaces/#{space.space_id}/book")
      fill_in('start', with: '2021/05/05')
      fill_in('end', with: '2021/06/06')
      click_button('Submit')
      expect(current_path).to eq('/spaces')
      expect(page).to have_content('ORDER PENDING')
    end
end