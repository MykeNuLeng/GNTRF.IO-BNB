require 'capybara/rspec'

def create_account_and_login
  User.create(email: "test@test.com", username: "brian", password: "test123")
  visit '/'
  fill_in('email', with: 'test@test.com')
  fill_in('password', with: 'test123')
  click_button('LOGIN')
end