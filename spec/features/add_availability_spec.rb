require 'capybara/rspec'
require 'space'
require 'user'

feature "Add Availability" do
  scenario "accessible by clicking button in profile spaces (when logged in)" do
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
    click_button('PROFILE')
    click_link('Spaces')
    expect(current_path).to eq('/profile/spaces')
    click_button("ADD AVAILABILITY")
    expect(current_path).to eq("/spaces/#{space.space_id}/add-availability")
  end

  scenario "contains two date input elements" do
    
  end
end
