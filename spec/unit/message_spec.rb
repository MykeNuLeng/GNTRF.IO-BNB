require 'message'
require 'user'
require './lib/database_connection'

describe Message do

  before do
    # need test users for valid user_id
    @test_user1 = User.create(username: "testy1", password: "123Password", email: "testymctesterson1@test.org")
    @test_user2 = User.create(username: "testy2", password: "123Password", email: "testymctesterson2@test.org")
  end

  it "Sends a message to the correct recipient when .send_message called" do
    expect { Message.send_message(my_id: @test_user1.user_id, recipient_id: @test_user2.user_id, content: "Urgent please reply")}.to change { DatabaseConnection.query("SELECT * FROM message WHERE user_id_from = #{@test_user1.user_id} AND user_id_to = #{@test_user2.user_id};").cmd_tuples }.by(1)
  end

  context " Inbox & outbox-- " do

    before do
      Message.send_message(my_id: @test_user1.user_id, recipient_id: @test_user2.user_id, content: "chronological message 1")
      sleep(2)
      Message.send_message(my_id: @test_user2.user_id, recipient_id: @test_user1.user_id, content: "chronological message 2")
      sleep(2)
      Message.send_message(my_id: @test_user1.user_id, recipient_id: @test_user2.user_id, content: "chronological message 3")
      sleep(2)
      Message.send_message(my_id: @test_user2.user_id, recipient_id: @test_user1.user_id, content: "chronological message 4")
    end

    it "Builds correct inbox" do
      inbox = Message.get_inbox(user_id: @test_user1.user_id)
      expect(inbox).to be_instance_of(Array)
      expect(inbox.length).to eq(2)
      expect(inbox.first.content).to eq("chronological message 4")
    end

    it "Builds correct outbox" do
      outbox = Message.get_outbox(user_id: @test_user1.user_id)
      expect(outbox).to be_instance_of(Array)
      expect(outbox.length).to eq(2)
      expect(outbox.first.content).to eq("chronological message 3")
    end
  end

end
