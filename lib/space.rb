require 'pg'
require_relative 'database_connection'

class Space
  attr_reader :space_id, :user_id, :price, :headline, :description, :image

  def initialize(space_id:, user_id:, price:, headline:, description:, image: 'https://via.placeholder.com/200x100')
    @space_id = space_id.to_i
    @user_id = user_id.to_i
    @price = price.to_i
    @headline = headline
    @description = description
    @image = image
  end

  # Create

  def self.create(user_id:, price:, headline:, description:, image: "https://via.placeholder.com/200x100")
    return false unless Space.valid_price?(price: price)
    return false unless headline.length < 160
    headline = Space.sub_apostrophe(headline)
    description = Space.sub_apostrophe(description)
    result = DatabaseConnection.query("INSERT INTO spaces (user_id, price, headline, description, image)
                              VALUES ('#{user_id}', '#{price}', '#{headline}', '#{description}', '#{image}')
                              RETURNING id;")
    Space.new(space_id: result[0]["id"], user_id: user_id, price: price, headline: headline, description: description, image: image)
  end

  # Read

  def self.all
    result = DatabaseConnection.query("SELECT * FROM spaces;")
    result.map{ |rental| Space.new(space_id: rental['id'], user_id: rental['user_id'], price: rental['price'], headline: rental['headline'], description: rental['description'], image: rental['image']) }
  end

  def self.open_dates(space_id:)
    owner_dates = Space.owner_dates(space_id: space_id)
    booked_dates = Space.booked_dates(space_id: space_id)
    open_dates = owner_dates.select {|day| !booked_dates.include?(day) }
  end

  def self.find(space_id:)
    result = DatabaseConnection.query("SELECT * FROM spaces WHERE id = '#{space_id}';")
    Space.new(
      space_id: result[0]['id'],
      user_id: result[0]['user_id'],
      price: result[0]['price'],
      headline: result[0]['headline'],
      description: result[0]['description']
    )
  end

  # Update

  def self.make_available(space_id:, start_date:, end_date:) # currently implementing dates to be passed as strings in format "yyyy/mm/dd" can change if needed
    DatabaseConnection.query("INSERT INTO availability (space_id, availability_start, availability_end)
                              VALUES (#{space_id}, '#{start_date}', '#{end_date}');")
  end

  def self.update_price(space_id:, price:)
    DatabaseConnection.query("UPDATE spaces SET price = #{price} WHERE id = '#{space_id}'")
  end

  def self.update_headline(space_id:, headline:)
    DatabaseConnection.query("UPDATE spaces SET headline = '#{headline}' WHERE id = '#{space_id}'")
  end

  def self.update_description(space_id:, description:)
    DatabaseConnection.query("UPDATE spaces SET description = '#{description}' WHERE id = '#{space_id}'")
  end

  # Delete

  def self.delete(space_id: )
    DatabaseConnection.query("DELETE FROM spaces WHERE id = #{space_id};")
  end

  private
  def self.clean_date(database_date)
    date_array = database_date.to_s.split("-")
    Time.new(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)
  end

  def self.owner_dates(space_id:)
    owner_day_array = self.build_date_array(DatabaseConnection.query("SELECT * FROM availability;"))
    owner_day_array.sort!
  end

  def self.booked_dates(space_id:)
    booked_day_array = self.build_date_array(DatabaseConnection.query("SELECT booking_start, booking_end
                                          FROM orders WHERE space_id = #{space_id};"))
    booked_day_array.sort!
  end

  def self.build_date_array(db_object)
    day_array = []
    db_object.each do |row|
      current_day = Space.starting_day(row)
      end_day = Space.ending_day(row)
      while current_day != end_day + (60 * 60 * 24)
        day_array << current_day
        current_day += (60 * 60 * 24)
      end
    end
    day_array
  end

  def self.starting_day(hash)
    if hash.key?("availability_start")
      return Space.clean_date(hash["availability_start"])
    else
      return Space.clean_date(hash["booking_start"])
    end
  end

  def self.ending_day(hash)
    if hash.key?("availability_end")
      return Space.clean_date(hash["availability_end"])
    else
      return Space.clean_date(hash["booking_end"])
    end
  end

  # edge cases

  def self.valid_price?(price:)
    return false if !(price.to_s =~ /\A\d+?\z/)
    true
  end

  def self.sub_apostrophe(text)
    text.gsub "'", "&#39;"
  end

end
