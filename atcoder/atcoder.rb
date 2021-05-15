# frozen_string_literal: true

require 'json'
require 'rest-client'

module Atcoder
  def submissions_all(username)
    JSON.parse(RestClient.get("https://kenkoooo.com/atcoder/atcoder-api/results?user=#{username}"))
  end
  module_function :submissions_all

  def submissions_within(username, date_from, date_by)
    submissions = JSON.parse(RestClient.get("https://kenkoooo.com/atcoder/atcoder-api/results?user=#{username}"))
    submissions.select { |item| item['epoch_second'] >= date_from && item['epoch_second'] < date_by }
  end
  module_function :submissions_within
end
