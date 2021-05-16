# frozen_string_literal: true

require 'json'
require 'pp'
require_relative './atcoder/atcoder'
require_relative './slack/slack'

# filter by date (UTC)
today = Date.today
lastweek = today - 7
today_es = Time.utc(today.year, today.month, today.day).to_i
lastweek_es = Time.utc(lastweek.year, lastweek.month, lastweek.day).to_i

shojins = Atcoder.submissions_within('yamm', lastweek_es, today_es)
difficulties = Atcoder.difficulties(shojins.map { |s| s['problem_id'] }.uniq)
results_hash = Atcoder.make_result_hash(shojins, difficulties)

Slack.send_report(results_hash, lastweek, today)
