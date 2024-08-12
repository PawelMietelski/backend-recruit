class MessagesCreator
  def call
    stream = $redis.xread "messages", 0
    return if stream_empty?(stream)

    stream["messages"].each do |mess|
      request = JSON.parse(mess[1]["request"])
      message_id = request["message_id"]
      next if message_exists?(message_id)

      save_message(message_id, request)
    end
  end

  private

  def save_message(message_id, request)
    message = Message.new(id: message_id)
    message.body = request["body"]
    create_attachments(request["attachments_urls"], message)
    message.save
  end

  def stream_empty?(stream)
    stream["messages"].nil?
  end

  def message_exists?(message_id)
    Message.exists?(id: message_id)
  end

  def create_attachments(attachments_urls, message)
    return if attachments_urls.nil?

    attachments_urls.each do |url|
      message.attachments.attach(io: File.open(url), filename: "message_#{message.id}_file")
    end
  end
end
