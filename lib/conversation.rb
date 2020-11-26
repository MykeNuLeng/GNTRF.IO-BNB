require './lib/database_connection'
require_relative './message'

class Conversation
  attr_reader :veiwer_id, :other_id

  def initialize(viewer_id:, other_id:)
    @viewer_id = viewer_id
    @other_id = other_id
  end

  def send_message(content:)
    content = sub_apostrophe(content)
    date = Time.now.strftime("%Y/%m/%d")
    time = Time.now.strftime("%H:%M:%S")
    DatabaseConnection.query("INSERT INTO message (user_id_from, user_id_to, content, date, time) VALUES (#{@viewer_id}, #{@other_id}, '#{content}', '#{date}', '#{time}');")
  end

  def see_messages
    all_messages = get_messages(@viewer_id, @other_id) + get_messages(@other_id, @viewer_id)
    all_messages.sort_by!(&:time)
    all_messages
  end

  private
  def sub_apostrophe(text)
    text.gsub "'", "&#39;"
  end

  def get_messages(from_id, to_id)
    result = DatabaseConnection.query("SELECT * FROM message WHERE user_id_from = #{from_id} AND user_id_to = #{to_id};")
    result.map do |each|
      Message.new(message_id: each["id"], user_id_from: each["user_id_from"], user_id_to: each["user_id_to"], content: each["content"], time: time_from_database(each["date"], each["time"]))
    end
  end

  def time_from_database(string_date, string_time)
    date_array = string_date.split("-")
    time_array = string_time.split(":")
    Time.new(date_array[0], date_array[1], date_array[2],
             time_array[0], time_array[1], time_array[2])
  end
end
