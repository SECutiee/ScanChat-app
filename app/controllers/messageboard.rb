# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat API
  class App < Roda
    route('messageboard') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?
      @messageboards_route = '/messageboards'

      routing.on(String) do |msgb_id|
        @message_route = "#{@messageboards_route}/#{msgb_id}"

        # GET /messageboards/[msgb_id]
        routing.get do
          msgb_info = LoadMessageboard.new(App.config).call(
            @current_account, msgb_id
          )
          messageboard = messageboard.new(msgb_info)

          view :messageboard, locals: {
            current_account: @current_account, messageboard: messageboard
          }
        rescue StandardError => e
          puts "#{e.inspect}\n#{e.backtrace}"
          flash[:e] = 'messageboard not found'
          routing.redirect @messageboards_route
        end

        # POST /messageboards/[msgb_id]/messages/
        routing.post('messages') do
          message_data = Form::NewMessage.new.call(routing.params)
          if message_data.failure?
            flash[:e] = Form.message_values(message_data)
            routing.halt
          end

          CreateNewMember.new(App.config).call(
            current_account: @current_account,
            messageboard_id: msgb_id,
            message_data: message_data.to_h
          )

          flash[:notice] = 'Your message was added'
        rescue StandardError => e
          puts e.inspect
          puts e.backtrace
          flash[:e] = 'Could not add message'
        ensure
          routing.redirect @message_route
        end
      end
      @messageboard_route = '/messageboard'

      # POST /messageboard/new
      # Create a new messageboard

      # GET /messageboard/new
      # Form to create a new messageboard
    end
  end
end
