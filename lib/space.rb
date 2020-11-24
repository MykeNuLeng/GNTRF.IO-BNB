require 'pg'
require_relative 'database_connection'

class Space
  attr_reader :space_id, :user_id, :price, :headline, :description

  def initialize(space_id:, user_id:, price:, headline:, description:)
    @space_id = space_id.to_i
    @user_id = user_id.to_i
    @price = price.to_i
    @headline = headline
    @description = description
  end

  def self.create(user_id:, price:, headline:, description:)
    result = DatabaseConnection.query("INSERT INTO spaces (user_id, price, headline, description)
                              VALUES ('#{user_id}', '#{price}', '#{headline}', '#{description}')
                              RETURNING id;")
    Space.new(space_id: result[0]["id"], user_id: user_id, price: price, headline: headline, description: description)
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM spaces;")
    result.map{ |rental| Space.new(space_id: rental['id'], user_id: rental['user_id'], price: rental['price'], headline: rental['headline'], description: rental['description']) }
  end

end
