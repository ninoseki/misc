# frozen_string_literal: true

require "parallel"
require "resolv"

def resolve(domain)
  Resolv.getaddress domain
rescue Resolv::ResolvError => _e
  nil
end

a = ("a".."z").to_a
tld = "xyz"

permutations = a.repeated_permutation(4).to_a
domains = Parallel.map(permutations) do |permutation|
  (1..9).map do |n|
    [
      permutation[0..1].join + n.to_s + permutation[2..].join + ".#{tld}",
      permutation[0..2].join + n.to_s + permutation[3..].join + ".#{tld}"
    ]
  end
end.flatten

Parallel.each(domains) do |domain|
  res = resolve(domain)
  puts [domain, res].join(",") if res
end
