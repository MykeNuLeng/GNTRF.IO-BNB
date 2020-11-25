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

  context "#create" do
    it "Adds one user to databaseafter calling" do
      expect { User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")}.to change{ DatabaseConnection.query("SELECT * FROM users").map{|e| e}.length }.by(1)
    end

    it "Returns user correctly after calling" do
      returned_user = User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
      expect(returned_user).to be_instance_of(User)
      expect(returned_user.user_id).to be_instance_of(Integer)
      expect(returned_user.username).to eq("testy")
      expect(returned_user.email).to eq("testymctesterson@test.org")
    end
  end

  it "Returns correct user, when .find called with id" do
    test_user = User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
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
      User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
      expect(User.authenticate(email: "testymctesterson@test.org", password: "abcdef")).to eq(false)
    end

    it "Returns full user object when email & password correct" do
      test_user = User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
      returned_user = User.authenticate(email: "testymctesterson@test.org", password: "123password")
      expect(test_user.user_id).to eq(returned_user.user_id)
      expect(test_user.username).to eq(returned_user.username)
      expect(test_user.email).to eq(returned_user.email)
    end
  end

end
