# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat API
  class App < Roda
    route('chatroom') do |routing|
      # routing.is do
      #   @chatroom_route = '/chatroom'
      #   view 'chatroom', locals: { current_account: @current_account }
      # end
      # POST /chatroom/new
      # Create a new chatroom

      # GET /chatroom/new
      # Form to create a new chatroom

      # GET /chatroom/:id
      # Show a chatroom
      routing.on String do |chatroom_id|
        routing.get do # TODO: make this secure, right now everybody can request it
          chatroom = LoadChatroom.new(App.config).call(@current_account, chatroom_id:)
          chatroom = Chatroom.new(chatroom)
          #  App.logger.info("Chatroom: #{@chatroom}")
          App.logger.info("routing: Current_account: #{@current_account}")
          view 'chatroom', locals: { chatroom:, current_account: @current_account }
        end
      end

      # GET /chatroom/:id/members
      # Show the members of a chatroom

      # GET /chatroom/:id/edit
      # Form to edit a chatroom

      # POST /chatroom/:id/edit
      # Edit a chatroom

      # POST /chatroom/messages
      # Create a new message in a chatroom
    end
  end
end
