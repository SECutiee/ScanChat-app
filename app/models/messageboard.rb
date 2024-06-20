# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Messageboard
    attr_reader :id, :is_anonymous, :thread, :thread_id, # basic info
                :owner, :messages, :policies # full details

    def initialize(mesbor_info)
      process_attributes(mesbor_info['attributes'])
      process_relationships(mesbor_info['relationships'])
      process_policies(mesbor_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @is_anonymous = attributes['is_anonymous']
      @thread = Thread.new(attributes['thread'])
      @thread_id = attributes['thread_id']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @messages = process_messages(relationships['messages'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_messages(messages_info)
      return nil unless messages_info

      Messages.new(messages_info)
    end
  end
end
