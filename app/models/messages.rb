# frozen_string_literal: true

require_relative 'chatroom'

module ScanChat
  # Behaviors of the currently logged in account
  class Messages
    attr_reader :all

    def initialize(msgs_list)
      # puts "These are Messages: #{msgs_list}"
      @all = msgs_list.map do |msg|
        Message.new(msg)
      end
    end
  end
end
