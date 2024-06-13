# frozen_string_literal: true

require_relative 'form_base'

module ScanChat
  module Form
    # Form for member email details
    class MemberUsername < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/account_details.yml')

      params do
        required(:username).filled(:string)
      end
    end
  end
end
