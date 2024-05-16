# frozen_string_literal: true

require './require_app'
require_app

run ScanChat::App.freeze.app
