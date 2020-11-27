feature 'you can message people' do
  scenario "there's a message button" do
    user1 = User.create(email: "test1@test.com", username: "brian1", password: "Testlength123")
    visit('/')
    fill_in('email', with: 'test1@test.com')
    fill_in('password', with: 'Testlength123')
    click_button('LOGIN')
    click_button('MESSAGES')
    expect(page.current_path).to eq '/messages/'+user1.user_id.to_s+'/inbox'
  end

  scenario 'user2 messages user1, user1 can see it' do
    user1 = User.create(email: "test1@test.com", username: "brian1", password: "Testlength123")
    user2 = User.create(email: "test2@test.com", username: "brian2", password: "Testlength123")
    message = Message.send_message(my_id: user2.user_id, recipient_id: user1.user_id, content: 'test')
    visit('/')
    fill_in('email', with: 'test1@test.com')
    fill_in('password', with: 'Testlength123')
    click_button('LOGIN')
    click_button("MESSAGES")
    expect(page).to have_content 'test'
    expect(page).to have_content 'brian2'
  end

  scenario 'user1 sends message to user2, user1 logs off, user 2 logs in and sees it' do
    user1 = User.create(email: "test1@test.com", username: "brian1", password: "Testlength123")
    user2 = User.create(email: "test2@test.com", username: "brian2", password: "Testlength123")

    visit('/')
    fill_in('email', with: 'test1@test.com')
    fill_in('password', with: 'Testlength123')
    click_button('LOGIN')
    click_button('MESSAGES')
    click_link('OUTBOX')
    click_link('NEW MESSAGE')
    fill_in("recipient", with: 'brian2')
    fill_in('content', with: 'test')
    click_button('SEND')
    click_button('LOG OUT')
    fill_in('email', with: 'test2@test.com')
    fill_in('password', with: 'Testlength123')
    click_button('LOGIN')
    click_button('MESSAGES')
    expect(page).to have_content 'test'
    expect(page).to have_content 'brian2'
  end

  scenario 'outbox functions as expected' do
    user1 = User.create(email: "test1@test.com", username: "brian1", password: "Testlength123")
    user2 = User.create(email: "test2@test.com", username: "brian2", password: "Testlength123")

    visit('/')
    fill_in('email', with: 'test1@test.com')
    fill_in('password', with: 'Testlength123')
    click_button('LOGIN')
    click_button('MESSAGES')
    click_link('OUTBOX')
    click_button('NEW MESSAGE')
    fill_in("recipient", with: 'brian2')
    fill_in('content', with: 'test')
    click_button('SEND')
    expect(page).to have_content 'brian2'
    expect(page).to have_content 'test'
  end
end
