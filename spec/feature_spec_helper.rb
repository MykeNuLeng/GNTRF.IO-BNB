require 'capybara/rspec'

def create_account_and_login
  user = User.create(email: "test@test.com", username: "brian", password: "Testlength123")
  visit '/'
  fill_in('email', with: 'test@test.com')
  fill_in('password', with: 'Testlength123')
  click_button('LOGIN')
  user
end

def create_landlord_with_space_and_login
  landlord = User.create(email: "leech@test.com", username: "parasite", password: "Testlength123")

  space = Space.create(
    user_id: landlord.user_id,
    price: 6900,
    headline: "Amazing space",
    description: "test"
  )
  visit('/')
  fill_in('email', with: 'leech@test.com')
  fill_in('password', with: 'Testlength123')
  click_button('LOGIN')

  return space
end
