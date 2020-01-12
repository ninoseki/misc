# frozen_string_literal: true

require "curb"
require "json"
require "oga"
require "parallel"

def title(body)
  doc = Oga.parse_html(body)
  doc.at_css("title").text
rescue ArgumentError, LL::ParserError, NoMethodError => _e
  nil
end

def check(ip)
  curb = Curl::Easy.new("http://example.com") do |curl|
    curl.timeout = 2.0
    curl.resolve = ["example.com:80:#{ip}"]
  end

  begin
    curb.perform
    body = curb.body_str.force_encoding('UTF-8')
    {
      ip: ip,
      title: title(body),
      body: body
    }
  rescue Curl::Err::ConnectionFailedError, Curl::Err::TimeoutError => e
    {
      ip: ip,
      title: nil,
      body: nil,
      error: e.to_s
    }
  end
end

def load_ipv4s(arguments)
  if arguments.length == 1
    argument = arguments.first
    return File.readlines(argument).map(&:chomp) if File.exist?(argument)
  end
  arguments
end

# Usage:
# bundle exec ruby vhost_detour/detour.rb 1.1.1.1 8.8.8.8 ...
# or
# bundle exec ruby vhost_detour/detour.rb ip.txt

ipv4s = load_ipv4s(ARGV)
results = Parallel.map(ipv4s) do |ip|
  check ip
end.compact.uniq

puts JSON.pretty_generate(results)
