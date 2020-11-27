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

  private
  def self.sub_apostrophe(text)
    text.gsub "'", "&#39;"
  end
end
