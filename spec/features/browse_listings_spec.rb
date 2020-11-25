require 'capybara/rspec'
require 'space'

feature "browse listings" do
  scenario "there are no listings" do
    visit '/spaces'
    expect(page).to have_content "NO CURRENT LISTINGS!"
  end

  scenario "displays the headline and price of a list of one space" do
    test_user = User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
    Space.create(user_id: test_user.user_id, price: 5400, headline: "Kinda alright space", description: "Really cheap, really damp!")
    visit '/spaces'
    expect(page).to have_content("Kinda alright space")
    expect(page).to have_content("£54")
  end

  scenario "displays the description of a list of two spaces" do
    test_user = User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
    Space.create(user_id: test_user.user_id, price: 5400, headline: "Kinda alright space", description: "Really cheap, really damp!")
    Space.create(user_id: test_user.user_id, price: 6900, headline: "Test test test", description: "Lovely property")
    visit '/spaces'
    expect(page).to have_content("Really cheap, really damp!")
    expect(page).to have_content("£54")
    expect(page).to have_content("Lovely property")
    expect(page).to have_content("£69")
  end
end
