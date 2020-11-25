require 'capybara/rspec'
require 'space'

feature "browse spaces" do
  scenario "there are no spaces" do
    visit '/spaces'
    expect(page).to have_content "NO CURRENT SPACES!"
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

  scenario "logo redirects logged in user to spaces" do
    User.create(email: "test@test.com", username: "brian", password: "test123")
    visit '/'
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'test123')
    click_button('LOGIN')
    find('.logo').click
    expect(current_path).to eq '/spaces'
    save_and_open_page('./test_output.html')
  end
end
