require 'capybara/rspec'

feature "Login/Register page" do
  scenario 'User has all the options required to log in' do
    visit '/'
    expect(page).to have_css('.logo')
    expect(page).not_to have_link('Login')
    expect(page).to have_link('Sign Up')
    expect(page).to have_field('email')
    expect(page).to have_field('password')
    expect(page).to have_button('Login')
  end

  scenario 'User has all the options required to register' do
    visit '/'
    click_button('Sign Up')
    expect(page).to have_link('Login')
    expect(page).not_to have_link('Sign Up')
    expect(page).to have_form('email')
    expect(page).to have_form('password')
    expect(page).to have_form('confirm-password')
    expect(page).to have_button('register')
  end
end