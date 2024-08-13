Rails.application.config.after_initialize do
  RedisMessagesListener.perform_later
end
