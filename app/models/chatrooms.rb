# frozen_string_literal: true

require_relative 'chatroom'

module ScanChat
  # Behaviors of the currently logged in account
  class Chatrooms
    attr_reader :all

    def initialize(chatrooms_list)
      if chatrooms_list.nil?
        @all = []
        return
      end
      @all = chatrooms_list.map do |chatr|
        Chatroom.new(chatr)
      end
    end
  end
end
