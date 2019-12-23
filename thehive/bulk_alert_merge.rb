# frozen_string_literal: true

require "hachi"
require "highline/import"

def api
  @api ||= Hachi::API.new
end

def yes_or_no(prompt)
  a = ""
  s = "[Y/n]"
  d = "y"
  until %w[y n].include? a
    a = ask("#{prompt} #{s} ") { |q| q.limit = 1; q.case = :downcase }
    a = d if a.empty?
  end
  a == "y"
end

description = ARGV[0].to_s
case_id = ARGV[1].to_s

alerts = api.alert.search(
  description: description,
  status: "New"
)

alert_ids = alerts.map { |alert| alert.dig "id" }
n = alert_ids.length
data = alerts.map do |alert|
  artifacts = alert.dig("artifacts") || []
  artifacts.map do |artifact|
    artifact.dig "data"
  end
end.flatten.compact.uniq
artifacts = data.empty? ? "N/A" : data.join(", ")

kase = api.case.get_by_id(case_id)
title = kase&.dig("title") || "N/A"

prompt = "Merge #{n} alerts(artifacts: #{artifacts}) into #{title}(##{case_id})?"

decision = yes_or_no(prompt)
if decision
  api.alert.merge_into_case(alert_ids, case_id)
  puts "Merged."
else
  puts "Canceled."
end
