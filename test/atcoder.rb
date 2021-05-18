# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require 'webmock/minitest'

require_relative '../atcoder/atcoder'

Minitest::Reporters.use!

class AtcoderTest < Minitest::Test
  def setup
    WebMock.stub_request(:get, 'https://kenkoooo.com/atcoder/atcoder-api/results?user=yamm')
           .to_return(
             status: 200,
             body: File.read('./test/json/submissions_yamm.json'),
             headers: {}
           )

    WebMock.stub_request(:get, 'https://kenkoooo.com/atcoder/resources/problem-models.json')
           .to_return(
             status: 200,
             body: File.read('./test/json/difficulties.json'),
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
