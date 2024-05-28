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

      response.parse['attributes']
    end
  end
end
