# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'

require_relative '../slack/slack'

Minitest::Reporters.use!

class SlackTest < Minitest::Test
  def test_atcoder_url_from_id
    assert_equal(
      'https://atcoder.jp/contests/abc200/tasks/abc200_a',
      Slack.atcoder_url_from_id('abc200_a')
    )
  end
end
