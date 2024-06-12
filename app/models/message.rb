# frozen_string_literal: true

require_relative 'thread'

module ScanChat
  # Behaviors of the currently logged in account
  class Message
    attr_reader :id, :sender_username, :sender_nickname, :sender_id, # basic msg_info
                :content # full details

    def initialize(msg_info)
      puts "Message: #{msg_info['attributes']}"
      process_attributes(msg_info['attributes'])
    end

    def process_attributes(attributes)
      @id = attributes['id']
      @content = attributes['content']
      @sender_username = attributes['sender_username']
      @sender_nickname = attributes['sender_nickname']
      @sender_id = attributes['sender_id']
    end
  end
end
