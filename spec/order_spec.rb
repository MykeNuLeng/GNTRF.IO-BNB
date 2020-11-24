require 'order'


describe Order do
  subject { Order.new(order_id: 1, space_id: 2, user_id: 3, booking_start: Time.new(2020, 11, 12), booking_end: Time.new(2020, 11, 13), confirmed: false) }

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
end
