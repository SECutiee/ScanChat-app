# frozen_string_literal: true

module ScanChat
  # Service to add member to project
  # @tritan ( is there member in messageboard?)
  class AddMemberToMessageboard
    class MemberNotAdded < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, member:, messageboard_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/messageboards/#{messageboard_id}/members",
                          json: { email: member[:email] })

      raise MemberNotAdded unless response.code == 200
    end
  end
end
