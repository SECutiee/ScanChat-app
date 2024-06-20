# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns a messageboard
  class GetMessageboardFromToken
    def initialize(config)
      @config = config
    end

    def call(current_account:, invite_token:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/messageboards/token/#{invite_token}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
