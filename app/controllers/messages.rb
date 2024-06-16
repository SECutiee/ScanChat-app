# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat App
  class App < Roda
    route('messages') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /messages/[msg_id]
      routing.get(String) do |msg_id|
        msg_info = GetMessage.new(App.config)
                             .call(@current_account, msg_id)
        message = Message.new(msg_info)

        view :message, locals: {
          current_account: @current_account, message:
        }
      end
    end
  end
end
