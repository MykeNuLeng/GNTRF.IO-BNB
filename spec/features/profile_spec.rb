require 'capybara/rspec'

feature "Profile page" do
  scenario "the route exists" do
    visit('/profile')
    expect(page.status_code).to eq(200)
  end

  scenario "accessible by clicking button in spaces" do
    visit('/spaces')
    click_button('PROFILE')
    expect(current_path).to eq('/profile')
  end

  scenario "accessible by clicking button in new spaces" do
    visit('/spaces/new')
    click_button('PROFILE')
    expect(current_path).to eq('/profile')
  end
end