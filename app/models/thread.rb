# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Thread
    attr_reader :id, :name, :owner, :description, :expiration_date, :messages, :is_expired

    def initialize(thread_info)
      process_attributes(thread_info['attributes'])
    end

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @owner = Account.new(attributes['owner'], nil)
      @description = attributes['description']
      @expiration_date = attributes['expiration_date']
      @is_expired = !@expiration_date.nil? && Time.parse(@expiration_date) < Time.now
      @messages = Messages.new(attributes['messages'])
    end
  end
end
