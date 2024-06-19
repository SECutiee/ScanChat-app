# frozen_string_literal: true

require_relative 'chatroom'

module ScanChat
  # Behaviors of the currently logged in account
  # need to adjust
  class Messageboards
    attr_reader :all

    def initialize(messageboards_list)
      @all = messageboards_list.map do |mesbor|
        Messageboard.new(mesbor)
      end
    end
  end
end
