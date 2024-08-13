class RedisMessagesListener < ApplicationJob
  queue_as :default

  def perform
    redis = Redis.new
    stream_name = 'messages'

    loop do
      stream = redis.xread(stream_name,'$', block: 1000)
      MessagesCreator.new.call(stream)
    end
  end
end
