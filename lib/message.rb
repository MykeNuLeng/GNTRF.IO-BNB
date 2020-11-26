class Message
  attr_reader :message_id, :user_id_from, :user_id_to, :content, :time

  def initialize(message_id:, user_id_from:, user_id_to:, content:, time:)
    @message_id = message_id.to_i
    @user_id_from = user_id_from.to_i
    @user_id_to = user_id_to.to_i
    @content = content
    @time = time
  end

end
