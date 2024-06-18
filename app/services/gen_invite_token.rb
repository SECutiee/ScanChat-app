# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns all details of an account
  class GenInviteToken
    # Error for accounts that cannot be seen
    class NoPermissionsError < StandardError
      def message
        'You are not authorized to create an invite QR code'
      end
    end

    def initialize(config)
      @config = config
    end

    def call(current_account:, thread_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/chatrooms/#{thread_id}/invite")
      raise NoPermissionsError if response.code != 200

      JSON.parse(response)['data']
      # App.logger.info("GenInviteToken: #{data}")
    end
  end
end
