# frozen_string_literal: true

require_relative 'thread'

module ScanChat
  # Behaviors of the currently logged in account
  class Message
    attr_reader :id, :sender_username, :sender_nickname, :sender_id, # basic info
                :content,
                :project # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['include'])
    end

    def process_attributes(attributes)
      @id = attributes['id']
      @content = attributes['content']
      @sender_username = attributes['sender_username']
      @sender_nickname = attributes['sender_nickname']
      @sender_id = attributes['sender_id']
    end

    def process_included(included)
      @project = Thread.new(included['thread'])
    end
  end
end
