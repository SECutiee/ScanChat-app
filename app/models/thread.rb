# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Thread
    attr_reader :id, :is_private

    def initialize(thread_info)
      @id = thread_info['attributes']['id']
      @name = thread_info['attributes']['name']
      @owner = Account.new(thread_info['attributes']['owner'])
      @description = thread_info['attributes']['description']
      @expiration_date = thread_info['attributes']['expiration_date']
    end
  end
end
