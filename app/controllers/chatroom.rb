# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat API
  class App < Roda
    route('chatroom') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?
      @chatrooms_route = '/chatrooms'

      routing.on(String) do |chatr_id|
        @chatroom_route = "#{@chatrooms_route}/#{chatr_id}"

        # GET /chatrooms/[chatr_id]
        routing.get do
          chatr_info = LoadChatroom.new(App.config).call(
            @current_account, chatr_id
          )
          chatroom = Chatroom.new(chatr_info)

          view :chatroom, locals: {
            current_account: @current_account, chatroom: chatroom
          }
        rescue StandardError => e
          puts "#{e.inspect}\n#{e.backtrace}"
          flash[:e] = 'Chatroom not found'
          routing.redirect @chatrooms_route
        end

        # POST /chatrooms/[chatr_id]/members
        routing.post('members') do
          action = routing.params['action']
          members_info = Form::MemberEmail.new.call(routing.params)
          if members_info.failure?
            flash[:e] = Form.validation_errors(members_info)
            routing.halt
          end

          task_list = {
            'add' => { service: AddMember,
                       message: 'Added new member to chatroom' },
            'remove' => { service: RemoveMember,
                          message: 'Removed member from chatroom' }
          }

          task = task_list[action]
          task[:service].new(App.config).call(
            current_account: @current_account,
            member: members_info,
            chatroom_id: chatr_id
          )
          flash[:notice] = task[:message]
        rescue StandardError
          flash[:e] = 'Could not find members'
        ensure
          routing.redirect @chatroom_route
        end

        # POST /chatrooms/[chatr_id]/messages/
        routing.post('messages') do
          message_data = Form::NewMessage.new.call(routing.params)
          if message_data.failure?
            flash[:e] = Form.message_values(message_data)
            routing.halt
          end

          CreateNewMember.new(App.config).call(
            current_account: @current_account,
            chatroom_id: chatr_id,
            message_data: message_data.to_h
          )

          flash[:notice] = 'Your message was added'
        rescue StandardError => e
          puts e.inspect
          puts e.backtrace
          flash[:e] = 'Could not add message'
        ensure
          routing.redirect @chatroom_route
        end
      end

      # POST /chatroom/new
      # Create a new chatroom

      # GET /chatroom/new
      # Form to create a new chatroom

      # GET /chatroom/:id/edit
      # Form to edit a chatroom

      # POST /chatroom/:id/edit
      # Edit a chatroom
    end
  end
end
