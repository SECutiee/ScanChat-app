# frozen_string_literal: true

require_relative 'form_base'

module ScanChat
  module Form
    # Form for creating a new chatroom
    class NewChatroom < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_chatroom.yml')

      params do
        required(:name).filled
      end
    end
  end
end
