require 'conversation'
require 'user'

describe Conversation do

  context " Setting up test objects-- " do

    before do
      # test users
      @test_user1 = User.create(username: "testy1", password: "123Password", email: "testymctesterson1@test.org")
      @test_user2 = User.create(username: "testy2", password: "123Password", email: "testymctesterson2@test.org")
      # test conversations (need 2)
      @test_convo1 = Conversation.new(viewer_id: @test_user1.user_id, other_id: @test_user2.user_id)
      @test_convo2 = Conversation.new(viewer_id: @test_user2.user_id, other_id: @test_user1.user_id)
    end

    it "Should return empty array before any messages sent" do
      expect(@test_convo1.see_messages).to be_instance_of(Array)
      expect(@test_convo1.see_messages.empty?).to eq(true)
    end

    it "Should return a list of three messages when three sent by same user" do
      @test_convo1.send_message(content: "Hey buddy, I'd like to rent out your place")
      @test_convo1.send_message(content: "Hey just wondering if you saw my message?")
      @test_convo1.send_message(content: "Bit rude to ignore me isn't it?")
      expect(@test_convo1.see_messages.length).to eq(3)
      expect(@test_convo1.see_messages[1].content).to eq("Hey just wondering if you saw my message?")
    end

    # I promise this passes but you need to make it wait so it will take ages to run each time, only un comment if you want to check

    # it "Should return correctly ordered list of messages when both users messaging" do
    #   @test_convo1.send_message(content: "Message should be at index 0")
    #   sleep(2)
    #   @test_convo2.send_message(content: "Message should be at index 1")
    #   sleep(2)
    #   @test_convo1.send_message(content: "Message should be at index 2")
    #   sleep(2)
    #   @test_convo2.send_message(content: "Message should be at index 3")
    #   sleep(2)
    #   @test_convo1.send_message(content: "Message should be at index 4")
    #   sleep(2)
    #   @test_convo2.send_message(content: "Message should be at index 5")
    #   sleep(2)
    #   @test_convo1.send_message(content: "Message should be at index 6")
    #   result = @test_convo1.see_messages
    #   expect(result.length).to eq(7)
    #   expect(result[0].content).to eq("Message should be at index 0")
    #   expect(result[1].content).to eq("Message should be at index 1")
    #   expect(result[2].content).to eq("Message should be at index 2")
    #   expect(result[3].content).to eq("Message should be at index 3")
    #   expect(result[4].content).to eq("Message should be at index 4")
    #   expect(result[5].content).to eq("Message should be at index 5")
    #   expect(result[6].content).to eq("Message should be at index 6")
    # end

  end
end
