# frozen_string_literal: true

module ScanChat
  # Service to add member to project
  class AddMemberToChatroom
    class MemberNotAdded < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, member:, chatroom_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/chatrooms/#{chatroom_id}/members",
                          json: { email: member[:email] })

      raise MemberNotAdded unless response.code == 200
    end
  end
end
