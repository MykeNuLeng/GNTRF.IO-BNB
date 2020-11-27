require 'message'
require 'user'
require './lib/database_connection'

describe Message do

  it "Sends a message to the correct recipient when .send_message called" do
    # need test users for valid user_id
    test_user1 = User.create(username: "testy1", password: "123Password", email: "testymctesterson1@test.org")
    test_user2 = User.create(username: "testy2", password: "123Password", email: "testymctesterson2@test.org")
    # test
    expect { Message.send_message(my_id: test_user1.user_id, recipient_id: test_user2.user_id, content: "Urgent please reply")}.to change { DatabaseConnection.query("SELECT * FROM message WHERE user_id_from = #{test_user1.user_id} AND user_id_to = #{test_user2.user_id};").cmd_tuples }.by(1)
  end

end
