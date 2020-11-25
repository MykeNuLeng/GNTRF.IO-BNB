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
    expect(page).to have_field('price')
    expect(page).to have_field('photo')
  end

  scenario "filling in said form will create a new space" do
    fill_in('headline', with: 'Test Property')
    fill_in('description', with: 'Lovely property')
    fill_in('price', with: '69')
    fill_in('photo', with: 'https://i.imgur.com/8KnWbIX.mp4')
    click_button('SUBMIT')
    expect(current_path).to eq('/spaces')
    expect(page).to have_content(/Test Property/)
    expect(page).to have_content(/Lovely property/)
    expect(page).to have_content(/£69/)
  end
end
