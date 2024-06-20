# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns an authenticated user, or nil
  class LoadMessageboard
    class UnauthorizedError < StandardError; end

    class ApiServerError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(current_account, messageboard_id:)
      # GET api/v1/messageboards/[thread_id]
      response = HTTP.auth("Bearer #{current_account.auth_token}").get("#{@config.API_URL}/messageboards/#{messageboard_id}")

      # App.logger.info("Service: Messageboard: #{response}")
      raise(UnauthorizedError) if response.code == 403
      raise(ApiServerError) if response.code != 200

      response.code == 200 ? JSON.parse(response.to_s) : nil
    rescue UnauthorizedError, ApiServerError
      nil
      # # GET api/v1/chatrooms/[thread_id]/messages
      # response = HTTP.auth("Bearer #{current_account.auth_token}").get("#{@config.API_URL}/chatrooms/#{chatroom_id}/messages")

      # raise(UnauthorizedError) if response.code == 403
      # raise(ApiServerError) if response.code != 200

      # messages = response.parse['data'].map { |message| message['attributes'] }
      # chatroom.concat(messages)

      # rescue ApiServerError
      #   chatroom = nil
      #   # messages = nil

      # App.logger.info("Chatroom: #{chatroom}")
    end
  end
end
