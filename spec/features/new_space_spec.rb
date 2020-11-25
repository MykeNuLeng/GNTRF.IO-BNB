feature 'new space' do
  before do
    User.create(email: "test@test.com", username: "brian", password: "test123")
    visit '/'
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'test123')
    click_button('LOGIN')
    click_button 'NEW LISTING'
  end

  scenario 'clicking on new listing takes you to the page' do
    expect(current_path).to eq '/spaces/new'
  end

  scenario 'being on spaces/new means you can fill in a form' do
    expect(page).to have_css('.logo')
    expect(page).not_to have_link('Log In')
    expect(page).to have_button 'PROFILE'
    expect(page).to have_button 'LOG OFF'
    expect(page).to have_button 'NEW LISTING'
    expect(page).to have_field('headline')
    expect(page).to have_field('description')
    expect(page).to have_field('photo')
  end
end
