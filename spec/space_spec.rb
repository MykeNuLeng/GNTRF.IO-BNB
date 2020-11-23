require 'space'
require 'user'
require 'pg'

describe Space do
  subject { Space.new(space_id: 1, user_id: 420, price: 15000, headline: "Amazing space", description: "Come stay in our place for kinda cheaps") }

  it "Correctly returns space_id" do
    expect(subject.space_id).to eq(1)
  end

  it "Correctly returns user_id" do
    expect(subject.user_id).to eq(420)
  end

  it "Correctly returns price" do
    expect(subject.price).to eq(15000)
  end

  it "Correctly returns headline" do
    expect(subject.headline).to eq("Amazing space")
  end

  it "Correctly returns description" do
    expect(subject.description).to eq("Come stay in our place for kinda cheaps")
  end

  context "#create" do
    it "Adds one user to databaseafter calling" do
      connection = PG.connect(dbname: 'bnb_test')
      # need test_user for valid user_id
      test_user = User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
      expect { Space.create(user_id: test_user.user_id, price: 15000, headline: "Amazing space", description: "Come stay in our place for kinda cheaps")}.to change{ connection.exec("SELECT * FROM spaces").map{|e| e}.length }.by(1)
    end

    it "Returns space correctly after calling" do
      connection = PG.connect(dbname: 'bnb_test')
      # need test_user for valid user_id
      test_user = User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
      returned_space = Space.create(user_id: test_user.user_id, price: 5400, headline: "Kinda alright space", description: "Really cheap, really damp!")
      expect(returned_space).to be_instance_of(Space)
      expect(returned_space.space_id).to be_instance_of(Integer)
      expect(returned_space.user_id).to eq(test_user.user_id)
      expect(returned_space.price).to eq(5400)
      expect(returned_space.headline).to eq("Kinda alright space")
      expect(returned_space.description).to eq("Really cheap, really damp!")
    end
  end

end
