# frozen_string_literal: true

require 'http'

module ScanChat
  # Returns all details of an account
  class GetAccountDetails
    # Error for accounts that cannot be seen
    class InvalidAccount < StandardError
      def message
        'You are not authorized to see details of that account'
      end
    end

    def initialize(config)
      @config = config
    end

    def call(current_account, username)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/accounts/#{username}")
      raise InvalidAccount if response.code != 200

      data = JSON.parse(response)['data']
      account_details = data['attributes']['account']
      auth_token = data['attributes']['auth_token']
      ScanChat::Account.new(account_details, auth_token)
    end
  end
end
