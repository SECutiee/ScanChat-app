# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns an authenticated user, or nil
  class LoadChatroom
    class UnauthorizedError < StandardError; end

    class ApiServerError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(chatroom_id:)
      response = HTTP.get("#{@config.API_URL}/chatrooms/#{chatroom_id}")

      raise(UnauthorizedError) if response.code == 403
      raise(ApiServerError) if response.code != 200

      chatroom = []
      chatroom.append(response.parse['attributes'])
      # GET api/v1/chatrooms/[thread_id]/messages
      response = HTTP.get("#{@config.API_URL}/chatrooms/#{chatroom_id}/messages")

      raise(UnauthorizedError) if response.code == 403
      raise(ApiServerError) if response.code != 200

      messages = response.parse['data'].map { |message| message['attributes'] }
      chatroom.concat(messages)
      # messages = response['data'].each { |message| message.parse['attributes'] }

      # chatroom.append(messages)
      # App.logger.info("Chatroom: #{chatroom}")

      chatroom
    end
  end
end
