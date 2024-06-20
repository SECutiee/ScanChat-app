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
            # puts "routing.params: #{routing.params}"
            msgb_data = Form::NewMessageboard.new.call(routing.params)
            if msgb_data.failure?
              flash[:e] = Form.message_values(msgb_data)
              routing.halt
            end
            # puts "msgb_data: #{msgb_data}"
            App.logger.info("post messageboard: #{msgb_data.to_h}")
            CreateNewMessageboard.new(App.config).call(
              current_account: @current_account,
              messageboard_data: msgb_data.to_h
            )

            flash[:notice] = 'Your messageboard was created'
          rescue StandardError => e
            App.logger.error(e.inspect)
            App.logger.error(e.backtrace)
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

        # /messageboards/[msgb_id]
        routing.on(String) do |msgb_id|
          @messageboard_route = "#{@messageboards_route}/#{msgb_id}"
          # POST /messageboards/[msgb_id]/edit
          routing.post('edit') do
            msgb_data = Form::EditMessageboard.new.call(routing.params)
            if msgb_data.failure?
              flash[:e] = Form.messageboard_values(msgb_data)
              routing.halt
            end
            App.logger.info("post messageboard: #{msgb_data.to_h}")
            EditMessageboard.new(App.config).call(
              current_account: @current_account,
              thread_id: msgb_id,
              messageboard_data: msgb_data.to_h
            )
            flash[:notice] = 'Your messageboard was updated'
          rescue StandardError => e
            routing.halt
            App.logger.info("#{e.inspect}\n#{e.backtrace}")
            flash[:e] = 'Could not update messageboard'
          ensure
            routing.redirect @messageboard_route
          end

          # GET /messageboards/[msgb_id]/invite
          routing.on('invite') do
            messageboard_info = GetMessageboard.new(App.config).call(
              @current_account,
              msgb_id
            )
            messageboard = Messageboard.new(messageboard_info) unless messageboard_info.nil?
            routing.get do
              view :invite_msgb, locals: {
                current_account: @current_account,
                messageboard:,
                base_url: request.base_url
              }
            end
          end

          # POST /messageboards/[msgb_id]/messages/
          routing.post('messages') do
            message_data = Form::NewMessage.new.call(routing.params)
            # App.logger.info("message_data: #{message_data}")
            if message_data.failure?
              # App.logger.info('validation failed')
              flash[:e] = Form.message_values(message_data)
              routing.halt
            end
            # App.logger.info('post test')
            AddNewMessageToMessageboard.new(App.config).call(
              current_account: @current_account,
              thread_id: msgb_id,
              message_data: message_data.to_h
            )

            # flash[:notice] = 'Your message was added'
          rescue StandardError => e
            App.logger.error "ERROR ADDING MESSAGE: #{e.inspect}"
            flash[:e] = 'Could not add message'
          ensure
            routing.redirect @messageboard_route
          end
          # GET /messageboards/[msgb_id]
          routing.get do
            mesbor_info = GetMessageboard.new(App.config).call(
              @current_account, msgb_id
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
      end
    end
  end
end
