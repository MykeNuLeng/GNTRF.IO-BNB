require 'user'
require 'pg'

describe User do
  subject { User.new(user_id: 1, username: "testy", email: "testymctesterson@test.org") }

  it "Returns user_id correctly" do
    expect(subject.user_id).to eq(1)
  end

  it "Returns username correctly" do
    expect(subject.username).to eq("testy")
  end

  it "Returns email correctly" do
    expect(subject.email).to eq("testymctesterson@test.org")
  end

  context " #create-- " do
    it "Adds one user to databaseafter calling" do
      expect { User.create(username: "testington", password: "123Password", email: "testymctesterson@test.org")}.to change{ DatabaseConnection.query("SELECT * FROM users").map{|e| e}.length }.by(1)
    end

    it "Returns user correctly after calling" do
      returned_user = User.create(username: "testington", password: "123Password", email: "testymctesterson@test.org")
      expect(returned_user).to be_instance_of(User)
      expect(returned_user.user_id).to be_instance_of(Integer)
      expect(returned_user.username).to eq("testington")
      expect(returned_user.email).to eq("testymctesterson@test.org")
    end

    context "edge case handling-- " do
      it "Returns false if the username is under 6 chars" do
        expect(User.create(username: "", password: "123Password", email: "test@test.com")).to eq(false)
        expect(User.create(username: "derp", password: "123Password", email: "test@test.com")).to eq(false)
      end

      it "Returns false if the username includes special characters" do
        expect(User.create(username: "@damthegreat", password: "123Password", email: "test@test.com")).to eq(false)
        expect(User.create(username: "whyuhatin!", password: "123Password", email: "test@test.com")).to eq(false)
        expect(User.create(username: "seamus_o'heany", password: "123Password", email: "test@test.com")).to eq(false)
        expect(User.create(username: "**************", password: "123Password", email: "test@test.com")).to eq(false)
      end

      it "Returns false if the username is not-unique" do
        User.create(username: "originalman", password: "123Password", email: "test@test.com")
        expect(User.create(username: "originalman", password: "123Password", email: "test@test.com")).to eq(false)
      end

      it "Returns false if the password is invalid" do
        expect(User.create(username: "testusername1", password: "Test12!", email: "test@test.com")).to eq(false)
        expect(User.create(username: "testusername2", password: "test12!!", email: "test@test.com")).to eq(false)
        expect(User.create(username: "testusername3", password: "TESTING12!", email: "test@test.com")).to eq(false)
        expect(User.create(username: "testusername4", password: "TestingOK", email: "test@test.com")).to eq(false)
      end

      it "Returns false if the email is invalid" do
        expect(User.create(username: "testusername1", password: "Test12!", email: "test.com")).to eq(false)
        expect(User.create(username: "testusername1", password: "Test12!", email: "test@test")).to eq(false)
        expect(User.create(username: "testusername1", password: "Test12!", email: "test@test@test.com")).to eq(false)
        expect(User.create(username: "testusername1", password: "Test12!", email: "te st@test.com")).to eq(false)
        expect(User.create(username: "testusername1", password: "Test12!", email: "te st@test.com")).to eq(false)
        expect(User.create(username: "testusername1", password: "Test12!", email: "test()\"[]<>;:,@test.com")).to eq(false)
        expect(User.create(username: "testusername1", password: "Test12!", email: "test\\@test.com")).to eq(false)
        expect(User.create(username: "testusername1", password: "Test12!", email: "123456789012345678457438589487534850435430599012345678901234567890123456789012345678901234+x@test.com")).to eq(false)
      end

      it "Returns false if the email contains any apostophe" do
        expect(User.create(username: "testusername1", password: "Test12!", email: "thomaso'leary@test.com")).to eq(false)
      end
    end

  end

  it "Returns correct user, when .find called with id" do
    test_user = User.create(username: "testington", password: "123Password", email: "testymctesterson@test.org")
    searched_user = User.find(user_id: test_user.user_id)
    expect(test_user.user_id).to eq(searched_user.user_id)
    expect(test_user.username).to eq(searched_user.username)
    expect(test_user.email).to eq(searched_user.email)
  end

  context "#authenticate" do
    it "Returns false if user not in database" do
      expect(User.authenticate(email: "wario@sega.net", password: "ihatemario")).to eq(false)
    end

    it "Returns false when email correct and password incorrect" do
      User.create(username: "testington", password: "123Password", email: "testymctesterson@test.org")
      expect(User.authenticate(email: "testymctesterson@test.org", password: "abcdef")).to eq(false)
    end

    it "Returns full user object when email & password correct" do
      test_user = User.create(username: "testington", password: "123Password", email: "testymctesterson@test.org")
      returned_user = User.authenticate(email: "testymctesterson@test.org", password: "123Password")
      expect(test_user.user_id).to eq(returned_user.user_id)
      expect(test_user.username).to eq(returned_user.username)
      expect(test_user.email).to eq(returned_user.email)
    end

    it "Ensures email/username is not case sensitive" do
      test_user = User.create(username: "tEsTy", password: "123password", email: "testymctesterson@test.org")
      returned_user = User.authenticate(email: "tEsTyMcTeStErSon@TeSt.OrG", password: "123password")
      expect(test_user.user_id).to eq(returned_user.user_id)
      expect(test_user.username).to eq(returned_user.username.downcase)
      expect(test_user.email).to eq(returned_user.email.downcase)
    end
  end

end
