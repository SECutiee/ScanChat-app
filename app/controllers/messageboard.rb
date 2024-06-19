# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat API
  class App < Roda
    route('messageboard') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @messageboards_route = '/messageboards'

        # POST /messageboards
        # Create a new messageboard
        routing.is do
          routing.post do
            mesbor_data = Form::NewMessageboard.new.call(routing.params)
            if mesbor_data.failure?
              flash[:e] = Form.messageboard_values(mesbor_data)
              routing.halt
            end
            App.logger.info("post messageboard: #{mesbor_data.to_h}")
            CreateNewMessageboard.new(App.config).call(
              current_account: @current_account,
              messageboard_data: mesbor_data.to_h
            )

            flash[:notice] = 'Your messageboard was created'
          rescue StandardError => e
            puts e.inspect
            puts e.backtrace
            flash[:e] = 'Could not create messageboard'
          ensure
            routing.redirect @messageboards_route
          end
          # GET /messageboards/
          # show the list of all messageboards
          routing.get do
            messageboard_list = GetAllMessageboards.new(App.config).call(@current_account)
            messageboards = Messageboards.new(messageboard_list)

            view :messageboards_all, locals: {
              current_account: @current_account, messageboards:
            }
          end
        end

        # /messageboards/[mesbor_id]
        routing.on(String) do |mesbor_id|
          @messageboard_route = "#{@messageboards_route}/#{mesbor_id}"

          # GET /messageboards/[mesbor_id]
          routing.get do
            mesbor_info = GetMessageboard.new(App.config).call(
              @current_account, mesbor_id
            )
            messageboard = Messageboard.new(mesbor_info) unless mesbor_info.nil?
            # App.logger.info("Chatroom: #{chatroom}")
            # App.logger.info("routing: Current_account: #{@current_account}")
            view :messageboard, locals: {
              current_account: @current_account, messageboard:
            }
          rescue StandardError => e
            App.logger.error "#{e.inspect}\n#{e.backtrace}"
            flash[:e] = 'Messageboard not found'
            routing.redirect @messageboards_route
          end

          # POST /messageboards/[mesbor_id]/edit
          routing.post('edit') do
            mesbor_data = Form::EditMessageboard.new.call(routing.params)
            if mesbor_data.failure?
              flash[:e] = Form.messageboard_values(mesbor_data)
              routing.halt
            end
            App.logger.info("post messageboard: #{mesbor_data.to_h}")
            EditMessageboard.new(App.config).call(
              current_account: @current_account,
              thread_id: mesbor_id,
              messageboard_data: mesbor_data.to_h
            )
            flash[:notice] = 'Your messageboard was updated'
          rescue StandardError => e
            routing.halt
            App.logger.info("#{e.inspect}\n#{e.backtrace}")
            flash[:e] = 'Could not update messageboard'
          ensure
            routing.redirect @messageboard_route
          end
          # # TODO: ensure all redirects
          # # POST /messageboards/[mesbor_id]/members
          # routing.post('members') do
          #   # App.logger.info('post members')
          #   action = routing.params['action']
          #   members_info = Form::MemberUsername.new.call(routing.params)
          #   if members_info.failure?
          #     flash[:e] = Form.validation_errors(members_info)
          #     routing.halt
          #   end
          #   # App.logger.info("members_info: #{members_info.to_h}")
          #   # App.logger.info("action: #{action}")
          #   task_list = {
          #     'add' => { service: AddMemberToChatroom,
          #                message: 'Added new member to chatroom' },
          #     'remove' => { service: RemoveMemberFromChatroom,
          #                   message: 'Removed member from chatroom' }
          #   }

          #   task = task_list[action]
          #   task[:service].new(App.config).call(
          #     current_account: @current_account,
          #     member: members_info.to_h,
          #     chatroom_id: chatr_id
          #   )
          #   flash[:notice] = task[:message]
          # rescue StandardError
          #   flash[:e] = 'Could not find members'
          # ensure
          #   routing.redirect @chatroom_route
          # end

          # POST /messageboards/[mesbor_id]/messages/
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
              thread_id: mesbor_id,
              message_data: message_data.to_h
            )

            # flash[:notice] = 'Your message was added'
          rescue StandardError => e
            App.logger.error "ERROR ADDING MESSAGE: #{e.inspect}"
            flash[:e] = 'Could not add message'
          ensure
            routing.redirect @messageboard_route
          end
        end

        # POST /messageboards/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?

          messageboard_data = Form::NewMessageboard.new.call(routing.params)
          if messageboard_data.failure?
            flash[:error] = Form.message_values(messageboard_data)
            routing.halt
          end

          CreateNewMessageboard.new(App.config).call(
            current_account: @current_account,
            messageboard_data: messageboard_data.to_h
          )

          flash[:notice] = 'Successfully create new messageboard'
        rescue StandardError => e
          App.logger.error "FAILURE Creating Messageboard: #{e.inspect}"
          flash[:error] = 'Could not create messageboard'
        ensure
          routing.redirect @messageboards_route
        end

        # GET /messageboards/
        routing.is do
          routing.get do
            messageboard_list = GetAllMessageboards.new(App.config).call(@current_account)

            messageboards = Messageboards.new(messageboard_list)

            view :messageboards_all, locals: {
              current_account: @current_account, messageboards:
            }
          end
        end
      end
    end
  end
end
