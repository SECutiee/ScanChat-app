# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat API
  class App < Roda
    route('messageboards') do |routing|
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

        # GET /messageboards/join
        routing.on('join') do
          routing.on(String) do |invite_token|
            # GET /messageboards/join/[token]
            routing.is do
              routing.get do
                mesbor_info = GetMessageboardFromToken.new(App.config).call(
                  current_account: @current_account,
                  invite_token:
                )
                App.logger.info("Messageboard info: #{mesbor_info}")
                messageboard = Messageboard.new(mesbor_info) unless mesbor_info.nil?
                App.logger.info("messageboard: #{messageboard}")
                view :join_messageboard, locals: {
                  current_account: @current_account,
                  messageboard:
                }
              end
            end
            # GET /messageboards/join/[token]/now ###################
            routing.get('now') do
              mesbor_info = GetMessageboardFromToken.new(App.config).call(
                current_account: @current_account,
                invite_token:
              )
              App.logger.info("Messageboard info: #{mesbor_info}")
              messageboard = Messageboard.new(mesbor_info) unless mesbor_info.nil?
              App.logger.info("messageboard: #{messageboard}")
              AddMemberToMessageboardFromToken.new(App.config).call(
                current_account: @current_account,
                chatroom_id: chatroom.thread.id,
                invite_token:
              )
              flash[:notice] = 'You have joined the chatroom'
            rescue StandardError => e
              puts e.inspect
              puts e.backtrace
              flash[:e] = 'Could not join chatroom'
            ensure
              routing.redirect @chatrooms_route + "/#{chatroom.thread.id}"
            end
          end
        end

        # /messageboards/[mesbor_id]
        routing.on(String) do |mesbor_id|
          @messageboard_route = "#{@messageboards_route}/#{mesbor_id}"
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

          # GET /chatrooms/[chatr_id]/invite #######################
          routing.on('invite') do
            routing.get do
              App.logger.info("get invite: thread_id: #{chatr_id}")
              invite_token = GenInviteToken.new(App.config).call(
                current_account: @current_account, thread_id: chatr_id
              )
              App.logger.info("invite_token: #{invite_token}")
              chatr_info = GetChatroom.new(App.config).call(
                @current_account, chatr_id
              )
              # puts "Chatroom info: #{chatr_info}"
              chatroom = Chatroom.new(chatr_info) unless chatr_info.nil?
              view :invite_member, locals: {
                current_account: @current_account,
                chatroom:,
                invite_token:,
                base_url: request.base_url
              }
            end
          end

          # POST /messageboards/[mesbor_id]/members #####################
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
              'add' => { service: AddMemberToMessageboard,
                         message: 'Added new member to messageboard' },
              'remove' => { service: RemoveMemberFromMessageboard,
                            message: 'Removed member from messageboard' }
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
            App.logger.error "ERROR ADDING MESSAGE: #{e.inspect}"
            flash[:e] = 'Could not add message'
          ensure
            routing.redirect @messageboard_route
          end
          # GET /messageboards/[mesbor_id]
          routing.get do
            mesbor_info = GetMessageboard.new(App.config).call(
              @current_account, mesbor_id
            )
            # puts "Messageboardinfo: #{mesbor_info}"
            messageboard = Messageboard.new(mesbor_info) unless mesbor_info.nil?
            # puts mesbor_info.nil?
            # App.logger.info("Messageboard: #{messageboard}")
            # App.logger.info("routing: Current_account: #{@current_account}")
            view :messageboard, locals: {
              current_account: @current_account, messageboard:
            }
          rescue StandardError => e
            App.logger.error "#{e.inspect}\n#{e.backtrace}"
            flash[:e] = 'Messageboard not found'
            routing.redirect @messageboards_route
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
            puts "here?"
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
