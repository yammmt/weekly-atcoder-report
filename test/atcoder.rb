# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require 'webmock/minitest'

require_relative '../atcoder/atcoder'

Minitest::Reporters.use!

class AtcoderTest < Minitest::Test
  def setup
    WebMock.stub_request(:get, 'https://kenkoooo.com/atcoder/atcoder-api/results?user=yamm')
           .with(
             headers: {
               'Accept' => '*/*',
               'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
               'Host' => 'kenkoooo.com',
               'User-Agent' => 'rest-client/2.1.0 (darwin20 x86_64) ruby/3.0.1p64'
             }
           )
           .to_return(
             status: 200,
             body: '[{"id":18981759,"epoch_second":1608898346,"problem_id":"agc006_a","contest_id":"agc006","user_id":"yamm","language":"Rust (1.42.0)","point":200.0,"length":488,"result":"AC","execution_time":6},{"id":18982621,"epoch_second":1608901700,"problem_id":"agc032_a","contest_id":"agc032","user_id":"yamm","language":"Rust (1.42.0)","point":400.0,"length":609,"result":"AC","execution_time":6},{"id":16465659,"epoch_second":1599050108,"problem_id":"abc173_d","contest_id":"abc173","user_id":"yamm","language":"Rust (1.42.0)","point":0.0,"length":334,"result":"WA","execution_time":41},{"id":16465498,"epoch_second":1599049732,"problem_id":"abc173_d","contest_id":"abc173","user_id":"yamm","language":"Rust (1.42.0)","point":400.0,"length":534,"result":"AC","execution_time":39}]',
             headers: {}
           )
  end

  def test_submissions_all
    submissions = Atcoder.submissions_all('yamm')
    assert_equal 4, submissions.size
  end

  def test_submissions_within
    date_from = Time.parse('2020-12-20 00:00:00').to_i
    date_by = Time.parse('2020-12-27 00:00:00').to_i
    submissions = Atcoder.submissions_within('yamm', date_from, date_by)
    assert_equal 2, submissions.size
  end

  def test_make_result_hash
    submissions = Atcoder.submissions_all('yamm')
    result_hash = Atcoder.make_result_hash(submissions)
    # key is "String" because API returns String
    assert_equal(
      {
        'agc006_a' => { 'AC' => 1 },
        'agc032_a' => { 'AC' => 1 },
        'abc173_d' => { 'AC' => 1, 'WA' => 1 }
      },
      result_hash
    )
  end
end
