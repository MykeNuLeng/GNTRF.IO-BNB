require 'capybara/rspec'

def create_account_and_login
  user = User.create(email: "test@test.com", username: "brian", password: "Testlength123")
  visit '/'
  fill_in('email', with: 'test@test.com')
  fill_in('password', with: 'Testlength123')
  click_button('LOGIN')
  user
end
