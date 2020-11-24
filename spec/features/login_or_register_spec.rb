require 'capybara/rspec'
require 'user'

feature "Login/Register page" do
  scenario 'User has all the options required to log in' do
    visit '/'
    expect(page).to have_css('.logo')
    expect(page).not_to have_link('Log In')
    expect(page).to have_link('Sign Up')
    expect(page).to have_field('email')
    expect(page).to have_field('password')
    expect(page).to have_button('LOGIN')
  end

  scenario 'User has all the options required to register' do
    visit '/'
    click_link('Sign Up')
    expect(page).to have_link('Log In')
    expect(page).not_to have_link('Sign Up')
    expect(page).to have_field('username')
    expect(page).to have_field('email')
    expect(page).to have_field('password')
    expect(page).to have_field('confirm-password')
    expect(page).to have_button('REGISTER')
  end

  scenario 'User successfully signs up' do
    visit '/'
    click_link('Sign Up')
    fill_in('email', with: 'test@test.com')
    fill_in('username', with: 'test')
    fill_in('password', with: 'test123')
    fill_in('confirm-password', with: 'test123')
    expect(User).to receive(:create).with(email: "test@test.com", username: "test", password: 'test123')
    click_button('REGISTER')
    expect(current_path).to eq('/')
  end

  scenario 'Valid user can sign in' do
    User.create(email: "test@test.com", username: "brian", password: "test123")
    visit '/'
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'test123')
    click_button('LOGIN')
    expect(current_path).to eq '/spaces'
    expect(page).to have_content(/brian/)
  end

  scenario 'non-user cannot sign in' do
    visit '/'
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'test123')
    click_button('LOGIN')
    expect(current_path).to eq '/'
    expect(page).to have_content(/EMAIL OR PASSWORD INVALID/)
  end
end
