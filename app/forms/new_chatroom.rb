# frozen_string_literal: true

require_relative 'form_base'

module ScanChat
  module Form
    # Form for creating a new chatroom
    class NewChatroom < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_chatroom.yml')

      params do # TODO: check formats
        required(:name).filled(:string)
        optional(:description).maybe(:string)
        required(:is_private).filled(:string)
        optional(:expiration_date).maybe(:string)
      end
    end
  end
end
