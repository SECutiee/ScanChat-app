# frozen_string_literal: true

require 'roda'
require_relative 'app'

module ScanChat
  # Web controller for ScanChat API
  class App < Roda
    route('messageboard') do |routing|
      @messageboard_route = '/messageboard'

      # POST /messageboard/new
      # Create a new messageboard

      # GET /messageboard/new
      # Form to create a new messageboard

      # GET /messageboard/:id
      # Show a messageboard
    end
  end
end
