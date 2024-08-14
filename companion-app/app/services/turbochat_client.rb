class TurbochatClient
  include HTTParty
  base_uri 'http://localhost:3000/api/'
  default_timeout 1

  def hide_message(id)
    handle_timeouts do
      request(
        http_method: :post,
        endpoint: "/messages/#{id}/hide"
      )
    end
  end

  private

  def request(http_method:, endpoint:, params: {})
    response = self.class.public_send(http_method, endpoint, params)

    return response
  end

  def handle_timeouts
    yield
  rescue Net::OpenTimeout, Net::ReadTimeout
    Rails.logger.error('Turbochat API Timeout error')
  end
end
