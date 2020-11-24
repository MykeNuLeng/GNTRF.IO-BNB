require 'pg'
require_relative './user'
require_relative 'database_connection'

class Order

  attr_reader :order_id, :space_id, :user_id, :booking_start, :booking_end, :confirmed

  def initialize(order_id:, space_id:, user_id:, booking_start:, booking_end:, confirmed:)
    @order_id = order_id.to_i
    @space_id = space_id.to_i
    @user_id = user_id.to_i
    @booking_start = clean_date(booking_start)
    @booking_end = clean_date(booking_end)
    @confirmed = confirmed
  end

  def self.create(space_id:, user_id:, booking_start:, booking_end:)
    result = DatabaseConnection.query("INSERT INTO orders (space_id, user_id, booking_start, booking_end)
                              VALUES ('#{space_id}', '#{user_id}', '#{booking_start}', '#{booking_end}')
                              RETURNING id, booking_start, booking_end;")
    Order.new(order_id: result[0]["id"], space_id: space_id, user_id: user_id, booking_start: result[0]["booking_start"], booking_end: result[0]["booking_end"], confirmed: false)
  end

  def self.all_pending
    result = DatabaseConnection.query("SELECT * FROM orders WHERE confirmed = 'false';")
    result.map { |listing|
      Order.new(order_id: listing['id'], space_id: listing['space_id'], user_id: listing['user_id'], booking_start: listing['booking_start'], booking_end: listing['booking_end'], confirmed: listing['confirmed']) }
  end

  def self.pending_by_id(user_id)
    Order.all_pending.select{ |listing| User.user_id == user_id }
  end

  def self.pending_by_username(username)
    Order.all_pending.select{ |listing| User.find(listing.user_id).username == username }
  end

  private
  def clean_date(database_date)
    date_array = database_date.to_s.split("-")
    Time.new(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)
  end
end
