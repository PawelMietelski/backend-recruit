class MessagesCreator
  def self.call
    stream = $redis.xread "messages", 0
    stream["messages"].each do |mess|
      request = JSON.parse(mess[1]["request"])
      message = Message.find_or_initialize_by(id: request["message_id"])
      message.body = request["body"]
      message.save
    end
  end
end
