# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns all messages belonging to a chatroom
  class GetChatroomMessages
    def initialize(config)
      @config = config
    end

    def call(user, chatr_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                     .get("#{@config.API_URL}/chatroom/#{chatr_id}/messages")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
