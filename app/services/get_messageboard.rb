# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns a messageboard
  class GetMessageboard
    def initialize(config)
      @config = config
    end

    def call(current_account, msgb_id)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/messageboards/#{msgb_id}")
      App.logger.info("GetMessageboard response: #{response}")
      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
