# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns all projects belonging to an account
  class GetAllChatrooms
    def initialize(config)
      @config = config
    end

    def call(current_account)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/chatrooms")

      response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
    end
  end
end
