require 'pg'
class Order

  attr_reader :order_id, :space_id, :user_id, :booking_start, :booking_end, :confirmed

  def initialize(order_id:, space_id:, user_id:, booking_start:, booking_end:, confirmed:)
    @order_id = order_id.to_i
    @space_id = space_id.to_i
    @user_id = user_id.to_i
    @booking_start = booking_start
    @booking_end = booking_end
    @confirmed = confirmed
  end
end
