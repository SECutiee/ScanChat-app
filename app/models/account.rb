# frozen_string_literal: true

module ScanChat
  # Behaviors of the currently logged in account
  class Account
    def initialize(account_info, auth_token = nil)
      @account_info = account_info
      @auth_token = auth_token
      # print("before account_info: #{@account_info} nil?: #{@account_info.nil?}")
      @account_info = @account_info if !@account_info.nil? && @auth_token.nil?
      # begin
      #   @account_info = @account_info['attributes']
      # rescue StandardError
      #   nil
      # end
      # print("after account_info: #{@account_info} nil?: #{@account_info.nil?}")
      # if (!@account_info.nil?) & @auth_token.nil? & (!@account_info['attributes'].nil?)
      #   @account_info = @account_info['attributes']
      # end
    end

    attr_reader :account_info, :auth_token, :nickname, :email, :username, :image

    def username
      @account_info ? @account_info['attributes']['username'] : nil
    end

    def email
      @account_info ? @account_info['attributes']['email'] : nil
    end

    def nickname
      nickname = @account_info ? @account_info['attributes']['nickname'] : nil
      if nickname.nil?
        username
      else
        nickname
      end
    end

    def image
      @account_info ? @account_info['attributes']['image'] : nil
    end

    def logged_out?
      @account_info.nil?
    end

    def logged_in?
      !logged_out?
    end
  end
end
