# frozen_string_literal: true

require 'dotenv'
require 'rest-client'

module Slack
  Dotenv.load
  WEBHOOK_URL = ENV['WEBHOOK_URL']

  def send_string(str)
    RestClient.post(WEBHOOK_URL, { 'text': str }.to_json)
  end
  module_function :send_string
end
