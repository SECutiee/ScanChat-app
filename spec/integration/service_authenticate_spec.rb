# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @scanchats = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @mal_scanchats = { username: 'soumya.ray', password: 'wrongpassword' }
    @api_account = { attributes:
                       { username: 'soumya.ray', email: 'sray@nthu.edu.tw' } }
  end

  after do
    WebMock.reset!
  end

  describe 'Find authenticated account' do
    it 'HAPPY: should find an authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: @scanchats.to_json)
             .to_return(body: @api_account.to_json,
                        headers: { 'content-type' => 'application/json' })

      account = ScanChat::AuthenticateAccount.new(app.config).call(**@credentials)
      _(account).wont_be_nil
      _(account['username']).must_equal @api_account[:attributes][:username]
      _(account['email']).must_equal @api_account[:attributes][:email]
    end

    it 'BAD: should not find a false authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: @mal_scanchats.to_json)
             .to_return(status: 403)
      _(proc {
        ScanChat::AuthenticateAccount.new(app.config).call(**@mal_scanchats)
      }).must_raise ScanChat::AuthenticateAccount::UnauthorizedError
    end
  end
end
