class MessagesCreator
  def call(stream)
    return if stream_empty?(stream)

    begin
      parse_stream(stream)
    rescue JSON::ParserError, IOError => e
      Rails.logger.error("Error reading from Redis stream: #{e.message}")
    end
  end

  private

  def parse_stream(stream)
    stream["messages"].each do |mess|
      request = JSON.parse(mess[1]["request"])
      message_id = request["message_id"]
      next if message_exists?(message_id)

      save_message(message_id, request)
    end
  end

  def save_message(message_id, request)
    message = Message.new(id: message_id)
    message.body = request["body"]
    create_attachments(request["attachments_file_paths"], message)
    message.save
  end

  def stream_empty?(stream)
    stream["messages"].nil?
  end

  def message_exists?(message_id)
    Message.exists?(id: message_id)
  end

  def create_attachments(attachments_file_paths, message)
    return if attachments_file_paths.nil?

    attachments_file_paths.each do |path|
      message.attachments.attach(io: File.open(path), filename: "message_#{message.id}_file")
    end
  end
end
