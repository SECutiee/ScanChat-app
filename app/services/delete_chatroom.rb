# frozen_string_literal: true

module ScanChat
  # Service to remove member from a chatroom
  class DeleteChatroom
    class ChatroomNotDeleted < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, thread_id:)
      # App.logger.info("RemoveMember: #{member} #{chatroom_id}")
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/chatrooms/#{thread_id}",
                             json: { thread_id: })
      App.logger.info("Delete Chatroom: #{response.code} #{response.body}")
      raise ChatroomNotDeleted unless response.code == 200
    end
  end
end
