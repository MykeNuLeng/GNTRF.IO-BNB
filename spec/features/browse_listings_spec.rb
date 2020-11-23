require 'capybara/rspec'

# testing only, remove!!!
class Listing
  def self.all_spaces

  end
end

feature "browse listings" do
  scenario "there are no listings" do
    visit '/listings'
    expect(page).to have_content "There are no listings"
  end

  scenario "displays the headline and price of a list of one Listing" do
    listing = double :listing, headline: "Phwoar, what a listing", price: 6000
    class_double = double('Listing')
    allow(Listing).to receive(:all_spaces).and_return([listing])
    expect(page).to have_content("Phwoar, what a listing")
    expect(page).to have_content("£60")
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