# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat API
  class App < Roda
    route('chatrooms') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @chatrooms_route = '/chatrooms'

        # POST /chatrooms
        # Create a new chatroom
        # routing.is do
        #   routing.post do
        #     routing.redirect '/auth/login' unless @current_account.logged_in?

        #     # chatroom_data = Form::NewChatroom.new
        #   end
        # end

        # GET /chatrooms/
        routing.is do
          routing.get do
            chatroom_list = GetAllChatrooms.new(App.config).call(@current_account)

            chatrooms = Chatrooms.new(chatroom_list)

            view :chatrooms_all, locals: {
              current_account: @current_account, chatrooms:
            }
          end
        end

        # GET /chatroom/:id
        #  Show a chatroom
        routing.on String do |chatroom_id|
          routing.get do # TODO: make this secure, right now everybody can request it
            chatroom = LoadChatroom.new(App.config).call(@current_account, chatroom_id:)
            # App.logger.info("controller: Chatroom: #{chatroom}")
            chatroom = Chatroom.new(chatroom) unless chatroom.nil?
            #  App.logger.info("Chatroom: #{@chatroom}")
            # App.logger.info("routing: Current_account: #{@current_account}")
            view 'chatroom', locals: { chatroom:, current_account: @current_account }
          end

          # POST /chatrooms/:id/messages
          # Create a new message in a chatroom
          routing.on 'messages' do
            routing.post do
              # do magic with the form services, clean the data etc.
              App.logger.info("routing: #{routing.params}")
              message_info = CreateMessage.new(App.config).call(
                current_account: @current_account,
                chatroom_id:,
                content: routing.params['message-content'],
                sender_id: @current_account.id
              )
              # verify message
            rescue StandardError => e
              App.logger.error "Could not process posting of message: #{e.inspect}"
              flash[:error] = 'Posting message failed -- please try later'
              routing.redirect @register_route
            end
          end
        end
      end
    end
  end
end
