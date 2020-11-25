feature 'can log out' do
  scenario 'clicking log out makes you log out...' do
    User.create(email: "test@test.com", username: "brian", password: "test123")
    visit '/'
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'test123')
    click_button('LOGIN')
    expect(current_path).to eq '/spaces'
    expect(page).to have_button 'LOG OFF'
    click_button 'LOG OFF'
    expect(page).to have_content "YOU'VE LOGGED OFF"
    expect(current_path).to eq '/'
  end
end
