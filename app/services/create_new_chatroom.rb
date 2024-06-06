# frozen_string_literal: true

require 'http'

module ScanChat
  # Create a new chatroom
  class CreateNewChatroom
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, chatroom_data:)
      config_url = "#{api_url}/chatrooms"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: chatroom_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
