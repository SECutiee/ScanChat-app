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
        routing.is do
          routing.post do
            chatr_data = Form::NewChatroom.new.call(routing.params)
            # App.logger.info("message_data: #{message_data}")
            if chatr_data.failure?
              # App.logger.info('validation failed')
              flash[:e] = Form.chatroom_values(chatr_data)
              routing.halt
            end
            App.logger.info("post chatroom: #{chatr_data.to_h}")
            CreateNewChatroom.new(App.config).call(
              current_account: @current_account,
              chatroom_data: chatr_data.to_h
            )

            flash[:notice] = 'Your chatroom was created'
          rescue StandardError => e
            puts e.inspect
            puts e.backtrace
            flash[:e] = 'Could not create chatroom'
          ensure
            routing.redirect @chatrooms_route
          end
          # GET /chatrooms/
          # show the list of all chatrooms
          routing.get do
            chatroom_list = GetAllChatrooms.new(App.config).call(@current_account)
            # App.logger.info("chatroom_list:#{chatroom_list}")
            chatrooms = Chatrooms.new(chatroom_list)

            view :chatrooms_all, locals: {
              current_account: @current_account, chatrooms:
            }
          end
        end

        # /chatrooms/[chatr_id]
        routing.on(String) do |chatr_id|
          @chatroom_route = "#{@chatrooms_route}/#{chatr_id}"

          # GET /chatrooms/[chatr_id]
          routing.get do
            chatr_info = GetChatroom.new(App.config).call(
              @current_account, chatr_id
            )
            # puts "Chatroom info: #{chatr_info}"
            chatroom = Chatroom.new(chatr_info) unless chatr_info.nil?
            # puts chatr_info.nil?
            # App.logger.info("Chatroom: #{chatroom}")
            # App.logger.info("routing: Current_account: #{@current_account}")
            view :chatroom, locals: {
              current_account: @current_account, chatroom:
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:e] = 'Chatroom not found'
            routing.redirect @chatrooms_route
          end

          # POST /chatrooms/[chatr_id]/edit
          routing.post('edit') do
            chatr_data = Form::EditChatroom.new.call(routing.params)
            if chatr_data.failure?
              flash[:e] = Form.chatroom_values(chatr_data)
              routing.halt
            end
            App.logger.info("post chatroom: #{chatr_data.to_h}")
            EditChatroom.new(App.config).call(
              current_account: @current_account,
              thread_id: chatr_id,
              chatroom_data: chatr_data.to_h
            )
            flash[:notice] = 'Your chatroom was updated'
          rescue StandardError => e
            routing.halt
            App.logger.info("#{e.inspect}\n#{e.backtrace}")
            flash[:e] = 'Could not update chatroom'
          ensure
            routing.redirect @chatroom_route
          end
          # TODO: ensure all redirects
          # POST /chatrooms/[chatr_id]/members
          routing.post('members') do
            # App.logger.info('post members')
            action = routing.params['action']
            members_info = Form::MemberUsername.new.call(routing.params)
            if members_info.failure?
              flash[:e] = Form.validation_errors(members_info)
              routing.halt
            end
            # App.logger.info("members_info: #{members_info.to_h}")
            # App.logger.info("action: #{action}")
            task_list = {
              'add' => { service: AddMemberToChatroom,
                         message: 'Added new member to chatroom' },
              'remove' => { service: RemoveMemberFromChatroom,
                            message: 'Removed member from chatroom' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              member: members_info.to_h,
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
            # App.logger.info("message_data: #{message_data}")
            if message_data.failure?
              # App.logger.info('validation failed')
              flash[:e] = Form.message_values(message_data)
              routing.halt
            end
            # App.logger.info('post test')
            AddNewMessage.new(App.config).call(
              current_account: @current_account,
              thread_id: chatr_id,
              message_data: message_data.to_h
            )

            # flash[:notice] = 'Your message was added'
          rescue StandardError => e
            puts e.inspect
            puts e.backtrace
            flash[:e] = 'Could not add message'
          ensure
            routing.redirect @chatroom_route
          end
        end
      end
    end
  end
end
