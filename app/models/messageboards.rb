# frozen_string_literal: true

require_relative 'messageboard'

module ScanChat
  # Behaviors of the currently logged in account
  class Messageboards
    attr_reader :all

    def initialize(messageboards_list)
      if messageboards_list.nil?
        @all = []
        return
      end
      @all = messageboards_list.map do |mesbor|
        Messageboard.new(mesbor)
      end
    end
  end
end
