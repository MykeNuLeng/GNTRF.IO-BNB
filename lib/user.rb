require 'pg'
require 'bcrypt'
require_relative 'database_connection'

class User
  attr_reader :user_id, :username, :email

  def initialize(user_id:, username:, email:)
    @user_id = user_id.to_i
    @username = username
    @email = email
  end

  def self.create(username:, password:, email:)
    return false unless User.valid_username?(username: username)
    return false unless User.valid_password?(password: password)
    return false unless User.valid_email?(email: email)
    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query("INSERT INTO users (username, password, email)
                              VALUES ('#{username}', '#{encrypted_password}', '#{email}')
                              RETURNING id;")
    User.new(user_id: result[0]["id"], username: username, email: email)
  end

  def self.find(user_id:) # this will cause an error if id not in database
    user_info = DatabaseConnection.query("SELECT * FROM users
                                 WHERE id = #{user_id};")[0]
    User.new(user_id: user_info["id"], username: user_info["username"], email: user_info["email"])
  end

  def self.authenticate(email:, password:)
    user_info = DatabaseConnection.query("SELECT * FROM users
                                 WHERE email = '#{email}';")
    return false unless user_info.cmd_tuples > 0 # nb that cmd_tuples is a pg object attribute for the number of database lines returned
    return false unless BCrypt::Password.new(user_info[0]["password"]) == password # nb might cause a problem if email's not unique
    User.new(user_id: user_info[0]["id"], username: user_info[0]["username"], email: email)
  end

  private
  def self.valid_username?(username:)
    return false if username.length < 5
    return false if !!(username =~ /[@€!£#$%^&*']/)
    return false if ((DatabaseConnection.query("SELECT username FROM users;")).map{|e| e["username"].downcase}).include?(username.downcase)
    true
  end

  def self.valid_password?(password:)
    return false if !(password =~ /^(?=.*\d)(?=.*([a-z]))(?=.*([A-Z]))([\x20-\x7E]){8,}$/ )
    true
  end

  def self.valid_email?(email:)
    return false if !(email =~ URI::MailTo::EMAIL_REGEXP)
    return false if email.include?("'")
    true
  end

end
