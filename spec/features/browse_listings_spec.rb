require 'capybara/rspec'
require 'space'

feature "browse listings" do
  scenario "there are no listings" do
    visit '/listings'
    expect(page).to have_content "There are no listings"
  end

  scenario "displays the headline and price of a list of one Listing" do
    space = double :space, headline: "Phwoar, what a listing", price: 6000
    class_double = double('Space')
    visit '/listings'
    allow(Space).to receive(:all_spaces).and_return([space])
    expect(page).to have_content("Phwoar, what a listing")
    expect(page).to have_content("£60")
  end
end
