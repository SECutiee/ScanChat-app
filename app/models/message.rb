# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Message
    attr_reader :id, :is_private

    def initialize(msg_info)
      @id = msg_info['attributes']['id']
      @content = msg_info['attributes']['content']
      @sender_username = msg_info['attributes']['sender_username']
      @sender_nickname = msg_info['attributes']['sender_nickname']
      @sender_id = msg_info['attributes']['sender_id']
      @thread = Thread.new(msg_info['attributes']['thread'])
    end
  end
end
