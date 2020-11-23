require 'capybara/rspec'

feature "browse listings" do
  scenario "there are no listings" do
    visit '/listings'
    expect(page).to have_content "There are no listings"
  end
end


# feature "navigation bar" do
#   scenario "has all of the required elements" do
#     visit('/')
#     expect(page).to have_button('Sign Up')
#     expect(page).to have_button('Sign In')
#   end

#   scenario "has log off button if logged in" do
#     visit('/logged-in-test')
#     expect(page).to have_button('Log Off')
#   end
# end