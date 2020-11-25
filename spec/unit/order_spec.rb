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

  it '.all pending returns an empty array if there is nothing pending' do
    expect(Order.all_pending.empty?).to eq true
  end

  context "Test users & space needed-- " do

    before do
      # need test users for valid user_id
      @space_owner = User.create(username: "testy1", password: "123password", email: "testymctesterson1@test.org")
      @order_owner = User.create(username: "testy2", password: "123password", email: "testymctesterson2@test.org")
      # need test space for valid space_id
      @test_space = Space.create(user_id: @space_owner.user_id, price: 2500, headline: "Livable space", description: "Rated \"not yet dangerous\" by official bodies")
    end

    it 'Adds one item to data base when .create called' do
      expect { Order.create(space_id: @test_space.space_id, user_id: @order_owner.user_id, booking_start: "2021-04-19", booking_end: "2021-04-21") }.to change{ DatabaseConnection.query("SELECT * FROM orders").map{|e| e}.length }.by(1)
    end

    context 'Test order also needed-- ' do

      before do
        # test order needed
        @test_order = Order.create(space_id: @test_space.space_id, user_id: @order_owner.user_id, booking_start: "2021/04/19", booking_end: "2021/04/21")
      end

      it 'Correctly returns created order after .create called' do
        expect(@test_order).to be_instance_of(Order)
        expect(@test_order.space_id).to eq(@test_space.space_id)
        expect(@test_order.user_id).to eq(@order_owner.user_id)
        expect(@test_order.booking_start.strftime("%Y-%m-%d")).to eq("2021-04-19")
        expect(@test_order.booking_end.strftime("%Y-%m-%d")).to eq("2021-04-21")
        expect(@test_order.confirmed).to eq(false)
      end

  #     it 'Returns an array of customer orders when .customer_order_history called' do
  #       test_order2 = Order.create(space_id: test_space.space_id, user_id: order_owner.user_id, booking_start: "2021/05/19", booking_end: "2021/05/21")
  #       Order.confirm(order_id: test_order.order_id)
  #       expect(Order.customer_order_history(order_owner.user_id).length).to eq 2
  #   end

      it 'changes something unconfirmed to confirmed when .confirm called' do
        Order.confirm(order_id: @test_order.order_id)
        expect(Order.all_pending.empty?).to eq true
      end

      it '.all_pending returns an array with pending orders' do
        expect(Order.all_pending).to be_instance_of(Array)
        expect(Order.all_pending.first).to be_an_instance_of(Order)
        expect(Order.all_pending.first.order_id).to eq(@test_order.order_id)
        expect(Order.all_pending.first.user_id).to eq(@test_order.user_id)
        expect(Order.all_pending.first.booking_start).to eq(@test_order.booking_start)
        expect(Order.all_pending.first.booking_end).to eq(@test_order.booking_end)
      end

      it ".pending_by_id returns array of pending orders by order owner id" do
        result = Order.pending_by_id(user_id: @order_owner.user_id)
        expect(result).to be_an_instance_of Array
        expect(result.first.booking_start).to eq @test_order.booking_start
      end

      it ".pending_by_username returns array of pending orders by order owner id" do
        result = Order.pending_by_username(username: 'testy2')
        expect(result).to be_an_instance_of Array
        expect(result.first.booking_start).to eq @test_order.booking_start
      end

    end # inner context end
  end # outer context end
end
