# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Chatroom
    attr_reader :id, :is_private

    def initialize(chatr_info)
      @id = chatr_info['attributes']['id']
      @is_private = chatr_info['attributes']['is_private']
    end
  end
end
