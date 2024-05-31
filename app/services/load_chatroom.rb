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

    def call(current_account, chatroom_id:)
      # GET api/v1/chatrooms/[thread_id]
      response = HTTP.auth("Bearer #{current_account.auth_token}").get("#{@config.API_URL}/chatrooms/#{chatroom_id}")
      App.logger.info("Service: Chatroom: #{response}")
      raise(UnauthorizedError) if response.code == 403
      raise(ApiServerError) if response.code != 200

      response.code == 200 ? JSON.parse(response.to_s) : nil
      # # GET api/v1/chatrooms/[thread_id]/messages
      # response = HTTP.auth("Bearer #{current_account.auth_token}").get("#{@config.API_URL}/chatrooms/#{chatroom_id}/messages")

      # raise(UnauthorizedError) if response.code == 403
      # raise(ApiServerError) if response.code != 200

      # messages = response.parse['data'].map { |message| message['attributes'] }
      # chatroom.concat(messages)
      # rescue UnauthorizedError
      #   chatroom = nil
      #   # messages = nil
      # rescue ApiServerError
      #   chatroom = nil
      #   # messages = nil

      # App.logger.info("Chatroom: #{chatroom}")
      # chatroom
    end
  end
end
