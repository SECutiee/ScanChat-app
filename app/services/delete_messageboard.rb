# frozen_string_literal: true

module ScanChat
  # Service to remove member from a messageboard
  class DeleteMessageboard
    class MessageboardNotDeleted < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, thread_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/messageboards/#{thread_id}",
                             json: { thread_id: })
      App.logger.info("Delete Messageboard: #{response.code} #{response.body}")
      raise MessageboardNotDeleted unless response.code == 200
    end
  end
end
