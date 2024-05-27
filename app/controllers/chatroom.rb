# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat API
  class App < Roda
    route('chatroom') do |routing|
      @chatroom_route = '/chatroom'

        # POST /chatroom/new
        # Create a new chatroom


        # GET /chatroom/new
        # Form to create a new chatroom


        # GET /chatroom/:id
        # Show a chatroom


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
