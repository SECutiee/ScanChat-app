# frozen_string_literal: true

require 'http'

module ScanChat
  # Create a new chatroom
  class EditChatroom
    class ChatroomNotEdited < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, thread_id:, chatroom_data:)
      config_url = "#{api_url}/chatrooms/#{thread_id}/edit"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put(config_url, json: chatroom_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise(ChatroomNotEdited)
    end
  end
end
