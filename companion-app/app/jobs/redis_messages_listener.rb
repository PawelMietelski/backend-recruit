class RedisMessagesListener < ApplicationJob
  queue_as :default

  def perform
    redis = Redis.new
    stream_name = 'messages'

    begin
      loop do
        stream = redis.xread(stream_name, '$', block: 1000)
        MessagesCreator.new.call(stream)
      end
    rescue Redis::BaseError => e
      Rails.logger.error("Redis error: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("General error: #{e.message}")
    ensure
      redis.close
    end
  end
end
