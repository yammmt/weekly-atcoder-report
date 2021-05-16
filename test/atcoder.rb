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

    WebMock.stub_request(:get, 'https://kenkoooo.com/atcoder/resources/problem-models.json')
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
             body: '{"abc053_b": {"slope": -0.0010491341272136543, "intercept": 7.286098473400458, "variance": 0.5313702359909696, "difficulty": 44, "discrimination": 0.004479398673070138, "irt_loglikelihood": -35.15041718429055, "irt_users": 248, "is_experimental": false}, "arc098_b": {"slope": -0.0011428052026327589, "intercept": 9.2169294174036, "variance": 0.47578028988922005, "difficulty": 1404, "discrimination": 0.004479398673070138, "irt_loglikelihood": -519.4895783350488, "irt_users": 1973, "is_experimental": false}, "abc114_d": {"slope": -0.0009335357745204813, "intercept": 8.865710254357056, "variance": 0.27672959617710574, "difficulty": 1337, "discrimination": 0.004479398673070138, "irt_loglikelihood": -512.0749100515103, "irt_users": 1519, "is_experimental": false}, "agc006_a": {"slope": -0.00119041627912907, "intercept": 8.65993961367503, "variance": 0.5185281607998291, "difficulty": 516, "discrimination": 0.004479398673070138, "irt_loglikelihood": -142.4160238924293, "irt_users": 602, "is_experimental": false}, "agc032_a": {"slope": -0.0007868349232453199, "intercept": 8.443982807197333, "variance": 0.40616958686525867, "difficulty": 738, "discrimination": 0.004479398673070138, "irt_loglikelihood": -1000.3774043050419, "irt_users": 1618, "is_experimental": false}, "abc173_d": {"slope": -0.0007976292014969545, "intercept": 8.11617105422058, "variance": 0.314796443743712, "difficulty": 720, "discrimination": 0.004479398673070138, "irt_loglikelihood": -4138.969331057054, "irt_users": 9693, "is_experimental": false} }',
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

  def test_difficulties
    problems = %w[abc053_b arc098_b]
    assert_equal(
      {
        'abc053_b' => 44,
        'arc098_b' => 1404
      },
      Atcoder.difficulties(problems)
    )
  end

  def test_make_result_hash
    submissions = Atcoder.submissions_all('yamm')
    difficulties = Atcoder.difficulties(submissions.map { |s| s['problem_id'] }.uniq)
    result_hash = Atcoder.make_result_hash(submissions, difficulties)

    # key is "String" because API returns String
    assert_equal(
      {
        'agc006_a' => { 'AC' => 1, 'difficulty' => 516 },
        'agc032_a' => { 'AC' => 1, 'difficulty' => 738 },
        'abc173_d' => { 'AC' => 1, 'WA' => 1, 'difficulty' => 720 }
      },
      result_hash
    )
  end
end
