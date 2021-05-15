# frozen_string_literal: true

require 'json'
require 'pp'
require_relative './atcoder/atcoder'

# filter by date (UTC)
today = Date.today
lastweek = today - 7
today_es = Time.utc(today.year, today.month, today.day).to_i
lastweek_es = Time.utc(lastweek.year, lastweek.month, lastweek.day).to_i

pp Atcoder.submissions_within('yamm', lastweek_es, today_es)
