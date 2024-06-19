# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  # need to adjust
  class Messageboard
    attr_reader :id, :is_anonymous

    def initialize(mesbor_info)
      @id = mesbor_info['attributes']['id']
      @is_anonymous = mesbor_info['attributes']['is_anonymous']
    end
  end
end
