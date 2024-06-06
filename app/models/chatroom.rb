# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Chatroom
    attr_reader :id, :is_private, :thread, :thread_id, :members

    def initialize(chatr_info)
      # App.logger.info "Chatroom: #{chatr_info}"
      @id = chatr_info['attributes']['id']
      @is_private = chatr_info['attributes']['is_private']
      @thread = Thread.new(chatr_info['attributes']['thread'])
      @thread_id = chatr_info['attributes']['thread_id']
      @members = Accounts.new(chatr_info['attributes']['members'])
    end
  end
end
