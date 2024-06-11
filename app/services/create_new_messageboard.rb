# frozen_string_literal: true

require 'http'

module ScanChat
  # Create a new messageboard
  class CreateNewMessageboard
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, messageboard_data:)
      config_url = "#{api_url}/messageboards"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: messageboard_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
