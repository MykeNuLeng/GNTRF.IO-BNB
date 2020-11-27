class Message
  attr_reader :message_id, :user_id_from, :user_id_to, :content, :time

  def initialize(message_id:, user_id_from:, user_id_to:, content:, time:)
    @message_id = message_id.to_i
    @user_id_from = user_id_from.to_i
    @user_id_to = user_id_to.to_i
    @content = content
    @time = time
  end

  def self.send_message(my_id:, recipient_id:, content:)
    content = Message.sub_apostrophe(content)
    date = Time.now.strftime("%Y/%m/%d")
    time = Time.now.strftime("%H:%M:%S")
    DatabaseConnection.query("INSERT INTO message (user_id_from, user_id_to, content, date, time) VALUES (#{my_id}, #{recipient_id}, '#{content}', '#{date}', '#{time}');")
  end

  def self.get_inbox(user_id:)
    result = DatabaseConnection.query("SELECT * FROM message WHERE user_id_to = #{user_id};")
    result.map do |each|
      Message.new(message_id: each["id"], user_id_from: each["user_id_from"], user_id_to: each["user_id_from"], content: each["content"], time: Message.time_from_database(each["date"], each["time"]))
    end.sort_by(&:time).reverse
  end

  def self.get_outbox(user_id:)
    result = DatabaseConnection.query("SELECT * FROM message WHERE user_id_from = #{user_id};")
    result.map do |each|
      Message.new(message_id: each["id"], user_id_from: each["user_id_from"], user_id_to: each["user_id_from"], content: each["content"], time: Message.time_from_database(each["date"], each["time"]))
    end.sort_by(&:time).reverse
  end

  private
  def self.sub_apostrophe(text)
    text.gsub "'", "&#39;"
  end

  def self.time_from_database(string_date, string_time)
    date_array = string_date.split("-")
    time_array = string_time.split(":")
    Time.new(date_array[0], date_array[1], date_array[2],
             time_array[0], time_array[1], time_array[2])
  end
end
