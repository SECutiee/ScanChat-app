# frozen_string_literal: true

require_relative 'form_base'

module ScanChat
  module Form
    # Form for adding a new message
    class EditMessageboard < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/edit_messageboard.yml')

      params do
        required(:name).filled(:string)
        optional(:description).maybe(:string)
        # required(:is_private).filled(:string)
        # optional(:expiration_date).maybe(:string)
      end
    end
  end
end
