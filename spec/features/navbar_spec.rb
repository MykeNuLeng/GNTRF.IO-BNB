require 'capybara/rspec'

feature "navigation bar" do
  scenario "has all of the required elements" do
    visit('/')
    expect(page).to have_button('Sign Up')
    expect(page).to have_button('Sign In')
  end

  scenario "has log off button if logged in" do
    visit('/logged-in-test')
    expect(page).to have_button('Log Off')
  end
end