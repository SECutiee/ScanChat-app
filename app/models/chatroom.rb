# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Chatroom
    attr_reader :id, :is_private, :thread, :thread_id, # basic info
                :owner, :members, :messages, :policies # full details

    def initialize(proj_info)
      process_attributes(proj_info)
      process_relationships(proj_info['relationships'])
      process_policies(proj_info['policies'])
    end

    private

    def process_attributes(attributes)
      App.logger.info "Chatroom: #{attributes}"
      @id = attributes['id']
      @is_private = attributes['is_private']
      @thread = Thread.new(attributes['thread'])
      @thread_id = attributes['thread_id']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @members = process_members(relationships['members'])
      @messages = process_messages(relationships['messages'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_messages(messages_info)
      return nil unless messages_info

      messages_info.map { |msg_info| Messages.new(msg_info) }
    end

    def process_members(members)
      return nil unless members

      members.map { |account_info| Account.new(account_info) }
    end
  end
end
