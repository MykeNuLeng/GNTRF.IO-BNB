require 'pg'
require 'bcrypt'

class User
  attr_reader :user_id, :username, :email

  def initialize(user_id:, username:, email:)
    @user_id = user_id.to_i
    @username = username
    @email = email
  end

  def self.create(username:, password:, email:)
    connection = PG.connect(dbname: 'bnb')
    connection = PG.connect(dbname: 'bnb_test') if ENV['ENVIRONMENT'] == 'test'
    encrypted_password = BCrypt::Password.create(password)
    result = connection.exec("INSERT INTO users (username, password, email)
                              VALUES ('#{username}', '#{encrypted_password}', '#{email}')
                              RETURNING id;")
    User.new(user_id: result[0]["id"], username: username, email: email)
  end

  def self.find(user_id:)
    connection = PG.connect(dbname: 'bnb')
    connection = PG.connect(dbname: 'bnb_test') if ENV['ENVIRONMENT'] == 'test'
    user_info = connection.exec("SELECT * FROM users
                                 WHERE id = #{user_id};")[0]
    User.new(user_id: user_info["id"], username: user_info["username"], email: user_info["email"])
  end

  def self.authenticate(username:, password:)
    connection = PG.connect(dbname: 'bnb')
    connection = PG.connect(dbname: 'bnb_test') if ENV['ENVIRONMENT'] == 'test'
    user_info = connection.exec("SELECT * FROM users
                                 WHERE username = '#{username}';")
    return false unless user_info.cmd_tuples > 0 # nb that cmd_tuples is a pg object attribute for the number of database lines returned
    return false unless BCrypt::Password.new(user_info[0]["password"]) == password # nb might cause a problem if username's not unique
    User.new(user_id: user_info[0]["id"], username: username, email: user_info[0]["email"])
  end

end
