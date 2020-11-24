require 'capybara/rspec'

feature "Login/Register page" do
  scenario 'User has all the options required to log in' do
    visit '/'
    expect(page).to have_css('.logo')
    expect(page).not_to have_link('Log In')
    expect(page).to have_link('Sign Up')
    expect(page).to have_field('email')
    expect(page).to have_field('password')
    expect(page).to have_button('Login')
  end

  scenario 'User has all the options required to register' do
    visit '/'
    click_link('Sign Up')
    expect(page).to have_link('Log In')
    expect(page).not_to have_link('Sign Up')
    expect(page).to have_field('email')
    expect(page).to have_field('password')
    expect(page).to have_field('confirm-password')
    expect(page).to have_button('Register')
  end
end