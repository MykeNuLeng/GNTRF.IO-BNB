require 'capybara/rspec'
require 'space'

feature "browse listings" do
  let(:space) {double :space, headline: "Phwoar, what a listing", price: 6000}
  let(:space2) {double :space2, headline: "Another listing omg", price: 7000}
  scenario "there are no listings" do
    visit '/listings'
    expect(page).to have_content "There are no listings"
  end

  scenario "displays the headline and price of a list of one Listing" do
    class_double = double('Space')
    visit '/listings'
    allow(Space).to receive(:all_spaces).and_return([space])
    expect(page).to have_content("Phwoar, what a listing")
    expect(page).to have_content("£60")
  end

  scenario "displays the healine and price of a list of two Listing" do
    class_double = double('Space')
    visit '/listings'
    allow(Space). to receive(:all_spaces).and_return([space, space2])
    expect(page).to have_content("Phwoar, what a listing")
    expect(page).to have_content("£60")
    expect(page).to have_content("Another listing omg")
    expect(page).to have_content("£70")
  end
end
