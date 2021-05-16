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

  def difficulties(problem_ids)
    difficulties = JSON.parse(RestClient.get('https://kenkoooo.com/atcoder/resources/problem-models.json'))

    ret = {}
    problem_ids.each do |pid|
      ret[pid] = if difficulties.key?(pid)
                   difficulties[pid]['difficulty']
                 else
                   0
                 end
    end
    ret
  end
  module_function :difficulties

  def make_result_hash(original_hash, difficulties)
    results_map = {}
    original_hash.each do |h|
      result = h['result']
      problem_id = h['problem_id']
      results_map[problem_id] = {} unless results_map.key?(problem_id)
      if results_map[problem_id].key?(result)
        results_map[problem_id][result] += 1
      else
        results_map[problem_id][result] = 1
      end
    end

    results_map.each { |r| results_map[r[0]]['difficulty'] = difficulties[r[0]] }

    results_map
  end
  module_function :make_result_hash
end
