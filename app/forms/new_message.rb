# frozen_string_literal: true

require_relative 'form_base'

module ScanChat
  module Form
    # Form for adding a new message
    class NewMessage < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_message.yml')

      params do
        required(:content).filled(:string)
      end
    end
  end
end
