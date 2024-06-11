# frozen_string_literal: true

require 'http'

module ScanChat
  # Add a new message to a chatroom
  class AddNewMessage
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, chatroom_id:, message_data:)
      config_url = "#{api_url}/chatroom/#{chatroom_id}/message"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: message_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
