# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns a chatroom
  class GetChatroom
    def initialize(config)
      @config = config
    end

    def call(current_account, chatr_id)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/chatrooms/#{chatr_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
