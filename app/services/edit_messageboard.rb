# frozen_string_literal: true

require 'http'

module ScanChat
  # Create a new messageboard
  class EditMessageboard
    class MessageboardNotEdited < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, thread_id:, messageboard_data:)
      config_url = "#{api_url}/messageboards/#{thread_id}/edit"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put(config_url, json: messageboard_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise(MessageboardNotEdited)
    end
  end
end
