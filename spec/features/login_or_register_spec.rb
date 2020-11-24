require 'capybara/rspec'

feature "Login/Register page" do
  scenario 'User has all the options required to log in' do
    visit '/'
    expect(page).to have_css('.logo')
    expect(page).not_to have_link('Log In')
    expect(page).to have_link('Sign Up')
    expect(page).to have_field('email')
    expect(page).to have_field('password')
    expect(page).to have_button('Login')
  end

  scenario 'User has all the options required to register' do
    visit '/'
    click_link('Sign Up')
    expect(page).to have_link('Log In')
    expect(page).not_to have_link('Sign Up')
    expect(page).to have_field('email')
    expect(page).to have_field('password')
    expect(page).to have_field('confirm-password')
    expect(page).to have_button('Register')
  end

  scenario 'User successfully signs up and signs in' do
    visit '/'
    click_link('Sign Up')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'test123')
    fill_in('confirm-password', with: 'test123')
    expect(User).to receive(:create).with(email: "test@test.com")
    click_button('Register')
    expect(current_path).to eq('/')
    fill_in('email', with: 'test@test.com')
    fill_in('password', with: 'test123')
    click_button('Login')
    expect(current_path).to eq '/listings'
    expect(page).to have_content(/test@test.com/)
  end

  # scenario 'User successfully logs in' do
  #   fill_in('')
  # end
end