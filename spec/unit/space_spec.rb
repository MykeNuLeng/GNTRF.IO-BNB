require 'space'
require 'user'
require 'order'
require './lib/database_connection'
#require 'pg'

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

  it '.all returns an empty array if theres nothing there' do
    expect(Space.all.empty?).to be true
  end

  context "Test user needed-- " do

    before do
      # need test_user for valid user_id
      @test_user = User.create(username: "testy", password: "123password", email: "testymctesterson@test.org")
    end

    it ".create adds one space to database after calling" do
      expect { Space.create(user_id: @test_user.user_id, price: 15000, headline: "Amazing space", description: "Come stay in our place for kinda cheaps")}.to change{ DatabaseConnection.query("SELECT * FROM spaces").map{|e| e}.length }.by(1)
    end

    it ".create returns space correctly after calling" do
      returned_space = Space.create(user_id: @test_user.user_id, price: 5400, headline: "Kinda alright space", description: "Really cheap, really damp!")
      expect(returned_space).to be_instance_of(Space)
      expect(returned_space.space_id).to be_instance_of(Integer)
      expect(returned_space.user_id).to eq(@test_user.user_id)
      expect(returned_space.price).to eq(5400)
      expect(returned_space.headline).to eq("Kinda alright space")
      expect(returned_space.description).to eq("Really cheap, really damp!")
    end

    context "Test space needed-- " do

      before do
        @test_space1= Space.create(user_id: @test_user.user_id, price: 15000, headline: "Amazing space", description: "Come stay in our place for kinda cheaps")
      end

      it '.all returns an array of all listed spaces' do
        test_space2 = Space.create(user_id: @test_user.user_id, price: 5400, headline: "Kinda alright space", description: "Really cheap, really damp!")

        expect(Space.all).to be_an_instance_of Array
        expect(Space.all[0]).to be_an_instance_of Space
        expect(Space.all[0].user_id).to eq @test_space1.user_id
        expect(Space.all[0].price).to eq @test_space1.price
        expect(Space.all[0].headline).to eq @test_space1.headline
        expect(Space.all[0].description).to eq @test_space1.description
        expect(Space.all.length).to eq 2
      end

      it "Correctly updates price when .update_price called" do
        Space.update_price(space_id: @test_space1.space_id, price: 30000)
        expect(Space.all[0].space_id).to eq(@test_space1.space_id)
        expect(Space.all[0].price).to eq(30000)
      end

      it "Correctly updates headline when .update_headline called" do
        Space.update_headline(space_id: @test_space1.space_id, headline: "passable")
        expect(Space.all[0].space_id).to eq(@test_space1.space_id)
        expect(Space.all[0].headline).to eq("passable")
      end

      it "Correctly updates description when .update_description called" do
        Space.update_description(space_id: @test_space1.space_id, description: "now with fewer bed bugs")
        expect(Space.all[0].space_id).to eq(@test_space1.space_id)
        expect(Space.all[0].description).to eq("now with fewer bed bugs")
      end

      it '.delete(space_id) deletes a space from the table' do
        Space.delete(space_id: @test_space1.space_id)
        expect(Space.all.length).to eq(0)
      end

      it "Inserts into availability table where .make_available called" do
        expect { Space.make_available(space_id: @test_space1.space_id, start_date: "2020/11/25", end_date: "2020/12/25") }.to change { (DatabaseConnection.query("SELECT * FROM availability;")).cmd_tuples }.by(1)
      end

      context "#open_dates" do

        it "Returns empty array when called and nothing has been input" do
          expect(Space.open_dates(space_id: @test_space1.space_id)).to be_instance_of(Array)
          expect(Space.open_dates(space_id: @test_space1.space_id).empty?).to eq(true)
        end

        it "Will return expected list of dates if only one availability row and no orders" do
          Space.make_available(space_id: @test_space1.space_id, start_date: "2020/11/25", end_date: "2020/11/30")
          days = Space.open_dates(space_id: @test_space1.space_id)
          expect(days).to be_instance_of(Array)
          expect(days.length).to eq(6)
          expect(days[2].strftime("%Y-%m-%d")).to eq("2020-11-27")
        end

        it "Will return expected list of dates if two availability rows and no orders" do
          Space.make_available(space_id: @test_space1.space_id, start_date: "2020/11/25", end_date: "2020/11/30")
          Space.make_available(space_id: @test_space1.space_id, start_date: "2020/12/10", end_date: "2020/12/15")
          days = Space.open_dates(space_id: @test_space1.space_id)
          expect(days).to be_instance_of(Array)
          expect(days.length).to eq(12)
          expect(days[2].strftime("%Y-%m-%d")).to eq("2020-11-27")
          expect(days[8].strftime("%Y-%m-%d")).to eq("2020-12-12")
        end

        it "Will return expected list of dates if one availability row and one order" do
          Space.make_available(space_id: @test_space1.space_id, start_date: "2020/11/20", end_date: "2020/11/30")
          Order.create(space_id: @test_space1.space_id, user_id: @test_user.user_id, booking_start: "2020/11/24", booking_end: "2020/11/26")
          days = Space.open_dates(space_id: @test_space1.space_id)
          expect(days).to be_instance_of(Array)
          expect(days.length).to eq(8)
          expect(days[2].strftime("%Y-%m-%d")).to eq("2020-11-22")
          expect(days[5].strftime("%Y-%m-%d")).to eq("2020-11-28")
        end


      end # open dates context end
    end # test space context end
  end # test user context end
end
