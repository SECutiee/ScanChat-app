# frozen_string_literal: true

module ScanChat
  # Service to remove member from a chatroom
  class RemoveMemberFromChatroom
    class MemberNotRemoved < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, member:, chatroom_id:)
      # App.logger.info("RemoveMember: #{member} #{chatroom_id}")
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/chatrooms/#{chatroom_id}/members",
                             json: { username: member[:username] })
      App.logger.info("RemoveMember: #{response.code} #{response.body}")
      raise MemberNotRemoved unless response.code == 200
    end
  end
end
