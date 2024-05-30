# frozen_string_literal: true

require_relative 'chatroom'

module ScanChat
  # Behaviors of the currently logged in account
  class Accounts
    attr_reader :all

    def initialize(accs_list)
      @all = accs_list.map do |acc|
        Account.new(acc)
      end
    end
  end
end
