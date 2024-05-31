# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Thread
    attr_reader :id, :name, :owner, :description, :expiration_date, :messages

    def initialize(thread_info)
      @id = thread_info['attributes']['id']
      @name = thread_info['attributes']['name']
      @owner = Account.new(thread_info['attributes']['owner'], nil)
      @description = thread_info['attributes']['description']
      @expiration_date = thread_info['attributes']['expiration_date']
      @messages = Messages.new(thread_info['attributes']['messages'])
    end
  end
end
