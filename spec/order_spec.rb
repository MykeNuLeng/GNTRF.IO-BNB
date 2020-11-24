require 'order'
require 'user'
require 'space'


describe Order do
  subject { Order.new(order_id: 1, space_id: 2, user_id: 3, booking_start: "2020-11-12", booking_end: "2020-11-13", confirmed: false) }

  it 'it correctly returns oder_id' do
    expect(subject.order_id).to eq 1
  end

  it 'it correctly returns space_id' do
    expect(subject.space_id).to eq 2
  end

  it 'it correctly returns user_id' do
    expect(subject.user_id).to eq 3
  end

  it 'it correctly returns booking_start' do
    expect(subject.booking_start).to eq Time.new(2020, 11, 12)
  end

  it 'it correctly returns booking_end' do
    expect(subject.booking_end).to eq Time.new(2020, 11, 13)
  end

  it 'it correctly returns confirmed' do
    expect(subject.confirmed).to eq false
  end

  context '#create' do
    it 'Adds one item to data base when called' do
      connection = PG.connect(dbname: 'bnb_test')
      # need test users for valid user_id
      space_owner = User.create(username: "testy1", password: "123password", email: "testymctesterson1@test.org")
      order_owner = User.create(username: "testy2", password: "123password", email: "testymctesterson2@test.org")
      # need test space for valid space_id
      test_space = Space.create(user_id: space_owner.user_id, price: 2500, headline: "Livable space", description: "Rated \"not yet dangerous\" by official bodies")
      # actual test
      expect { Order.create(space_id: test_space.space_id, user_id: order_owner.user_id, booking_start: "2021-04-19", booking_end: "2021-04-21") }.to change{ connection.exec("SELECT * FROM orders").map{|e| e}.length }.by(1)
    end

    it 'Correctly returns created order after called' do
      # need test users for valid user_id
      space_owner = User.create(username: "testy1", password: "123password", email: "testymctesterson1@test.org")
      order_owner = User.create(username: "testy2", password: "123password", email: "testymctesterson2@test.org")
      # need test space for valid space_id
      test_space = Space.create(user_id: space_owner.user_id, price: 2500, headline: "Livable space", description: "Rated \"not yet dangerous\" by official bodies")
      # tests
      test_order = Order.create(space_id: test_space.space_id, user_id: order_owner.user_id, booking_start: "2021/04/19", booking_end: "2021/04/21")
      expect(test_order).to be_instance_of(Order)
      expect(test_order.space_id).to eq(test_space.space_id)
      expect(test_order.user_id).to eq(order_owner.user_id)
      expect(test_order.booking_start.strftime("%Y-%m-%d")).to eq("2021-04-19")
      expect(test_order.booking_end.strftime("%Y-%m-%d")).to eq("2021-04-21")
      expect(test_order.confirmed).to eq(false)
    end


  end
end
