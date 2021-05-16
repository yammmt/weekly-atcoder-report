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

  # TODO: too complicated: split them (in this module?)
  # TODO: add test
  def send_report(results_hash, date_from, date_by)
    acs = 0
    results_hash.each { |h| acs += 1 if h[1].key?('AC') }

    msg = {
      "blocks": [
        {
          "type": 'header',
          "text": {
            "type": 'plain_text',
            "text": ':newspaper: weekly atcoder report :newspaper:'
          }
        },
        {
          "type": 'context',
          "elements": [
            {
              "text": "[#{date_from}, #{date_by}]",
              "type": 'mrkdwn'
            }
          ]
        },
        {
          "type": 'divider'
        },
        {
          "type": 'section',
          "text": {
            "type": 'mrkdwn',
            "text": ' :loud_sound: *Total* :loud_sound:'
          }
        },
        {
          "type": 'section',
          "text": {
            "type": 'mrkdwn',
            "text": "Last week, you solved #{acs} problems! :tada:"
          }
        }
      ]
    }

    results_hash = results_hash.sort
    results_hash.each do |h|
      msg[:blocks].push({ type: 'divider' })
      problem_id = h[0]
      problem_url = atcoder_url_from_id(problem_id)
      msg[:blocks].push({
                          type: 'section',
                          text: {
                            type: 'mrkdwn',
                            text: ":clap: <#{problem_url} | #{problem_id}> (diff: #{h[1]['difficulty']})"
                          }
                        })

      counter_array = []
      h[1].each { |kv| counter_array.push("#{kv[0]}: #{kv[1]}") unless kv[0] == 'difficulty' }
      counter_array = counter_array.sort
      results_str = ''
      counter_array.each { |c| results_str = "#{results_str}- #{c}\n" }

      msg[:blocks].push({
                          type: 'section',
                          text: {
                            'type': 'mrkdwn',
                            'text': results_str
                          }
                        })
    end

    RestClient.post(WEBHOOK_URL, msg.to_json)
  end
  module_function :send_report

  def atcoder_url_from_id(id)
    "https://atcoder.jp/contests/#{id.split('_')[0]}/tasks/#{id}"
  end
  module_function :atcoder_url_from_id
end
