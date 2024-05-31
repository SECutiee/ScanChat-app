# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Message
    attr_reader :id, :content, :sender_username, :sender_nickname, :sender_id

    def initialize(msg_info)
      @id = msg_info['attributes']['id']
      @content = msg_info['attributes']['content']
      @sender_username = msg_info['attributes']['sender_username']
      @sender_nickname = msg_info['attributes']['sender_nickname']
      @sender_id = msg_info['attributes']['sender_id']
    end
  end
end
