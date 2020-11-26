require 'pg'
require_relative './user'
require_relative 'database_connection'

class Order

  attr_reader :order_id, :space_id, :user_id, :booking_start, :booking_end, :confirmed, :total_price

  def initialize(order_id:, space_id:, user_id:, booking_start:, booking_end:, confirmed:)
    @order_id = order_id.to_i
    @space_id = space_id.to_i
    @user_id = user_id.to_i
    @booking_start = clean_date(booking_start)
    @booking_end = clean_date(booking_end)
    @confirmed = confirmed
    @total_price = calculate_price
  end

  # Create

  def self.create(space_id:, user_id:, booking_start:, booking_end:)
    result = DatabaseConnection.query("INSERT INTO orders (space_id, user_id, booking_start, booking_end)
                              VALUES ('#{space_id}', '#{user_id}', '#{booking_start}', '#{booking_end}')
                              RETURNING id, booking_start, booking_end;")
    Order.new(order_id: result[0]["id"], space_id: space_id, user_id: user_id, booking_start: result[0]["booking_start"], booking_end: result[0]["booking_end"], confirmed: false)
  end

  # Read

  def self.all_pending
    result = DatabaseConnection.query("SELECT * FROM orders WHERE confirmed = 'false';")
    result.map { |listing|
      Order.new(order_id: listing['id'], space_id: listing['space_id'], user_id: listing['user_id'], booking_start: listing['booking_start'], booking_end: listing['booking_end'], confirmed: false) }
  end

  # Read - renter

  def self.order_history_by_renter_id(user_id: )
    result = DatabaseConnection.query("SELECT * FROM orders WHERE user_id = #{user_id};")
    result.map { |listing|
      Order.new(order_id: listing['id'], space_id: listing['space_id'], user_id: listing['user_id'], booking_start: listing['booking_start'], booking_end: listing['booking_end'], confirmed: Order.clean_boolean(listing['confirmed'])) }
  end

  def self.pending_by_renter_id(user_id:)
    Order.all_pending.select{ |listing| listing.user_id == user_id }
  end

  def self.pending_by_renter_username(username:)
    Order.all_pending.select{ |listing| User.find(user_id: listing.user_id).username == username }
  end

   # Read - landlord

  def self.order_history_by_landlord_id(user_id: )
    result = DatabaseConnection.query("SELECT spaces.user_id, orders.id, space_id, orders.user_id, booking_start, booking_end, confirmed
                                       FROM orders INNER JOIN spaces
                                       ON spaces.id = orders.space_id
                                       AND spaces.user_id = #{user_id};")
    result.map { |listing|
      Order.new(order_id: listing['id'], space_id: listing['space_id'], user_id: listing['user_id'], booking_start: listing['booking_start'], booking_end: listing['booking_end'], confirmed: Order.clean_boolean(listing['confirmed'])) }
  end

  def self.pending_by_landlord_id(user_id:)
    Order.order_history_by_landlord_id(user_id: user_id).select{|e| e.confirmed == false}
  end

  # Update

  def self.confirm(order_id:)
    DatabaseConnection.query("UPDATE orders SET confirmed = true WHERE id = '#{order_id}';")
  end

  # Delete

  def self.reject(order_id:)
    DatabaseConnection.query("DELETE FROM orders WHERE id = #{order_id};")
  end

  private
  def clean_date(database_date)
    date_array = database_date.to_s.split("-")
    Time.new(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)
  end

  def self.clean_boolean(database_value)
    return true if database_value == "t"
    return false if database_value == "f"
  end

  def calculate_price
    days = (((@booking_end - @booking_start) / 86400) + 1).to_i 
    price = DatabaseConnection.query("SELECT price FROM spaces WHERE id = #{@space_id};")[0]['price'].to_i
    days * price
  end

end
