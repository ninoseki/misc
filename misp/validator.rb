# frozen_string_literal: true

require "addressable/uri"
require "ipaddr"
require "public_suffix"

class Validator
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def valid?
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end
end

module Validators
  class IPv4 < Validator
    def valid?
      IPAddr.new data
      true
    rescue IPAddr::InvalidAddressError => _e
      false
    end
  end

  class Domain < Validator
    def valid?
      uri = Addressable::URI.parse("http://#{data}")
      uri.host == data && PublicSuffix.valid?(uri.host, default_rule: nil)
    rescue Addressable::URI::InvalidURIError => _e
      false
    end
  end

  class URL < Validator
    def valid?
      uri = Addressable::URI.parse(data)
      uri.scheme && uri.host && uri.path && PublicSuffix.valid?(uri.host)
    rescue Addressable::URI::InvalidURIError => _e
      false
    end
  end
end
