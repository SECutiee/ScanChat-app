# frozen_string_literal: true

require 'http'

module ScanChat
  # Add a new message to a chatroom
  class AddNewMessageToChatroom
    class MessageNotAdded < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, thread_id:, message_data:)
      config_url = "#{api_url}/chatrooms/#{thread_id}/messages"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: message_data)

      raise(MessageNotAdded) unless response.code == 201

      JSON.parse(response.body.to_s)
    end
  end
end
