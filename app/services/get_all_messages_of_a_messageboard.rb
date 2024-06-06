# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns all messages belonging to a messageboard
  class GetMessageboardMessages
    def initialize(config)
      @config = config
    end

    def call(user, msgb_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                     .get("#{@config.API_URL}/messageboard/#{msgb_id}/messages")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
