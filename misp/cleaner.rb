# frozen_string_literal: true

require "misp"
require "highline/import"

require_relative "./validator"

class Cleaner
  MAPPING_TALBE = {
    "ip-dst": Validators::IPv4,
    "domain": Validators::Domain,
    "url": Validators::URL,
  }.freeze

  DEFAULT_LIMIT = 100

  def find_invalid_attributes
    types.map do |type|
      attributes = get_attributes(type)
      attributes.reject do |attr|
        klass = MAPPING_TALBE[type]
        validator = klass.new(attr.value)
        validator.valid?
      end
    end.flatten
  end

  class << self
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

    def delete_with_prompt(attr)
      detail = "attibute (value: #{attr.value}, type: #{attr.type}, event_id: #{attr.event_id})"
      prompt = "Do you want to delete #{detail}?"

      decision = yes_or_no(prompt)
      if decision
        attr.delete
        puts "#{detail} is deleted."
      else
        puts "#{detail} is not deleted."
      end
    end
  end

  private

  def types
    MAPPING_TALBE.keys
  end

  def get_attributes(type)
    attributes = []

    (0..Float::INFINITY).each do |page|
      attrs = MISP::Attribute.search(type: type, page: page)
      attributes << attrs
      break if attrs.length < DEFAULT_LIMIT
    end

    attributes.flatten
  end
end

cleaner = Cleaner.new
invalid_attributes = cleaner.find_invalid_attributes
if invalid_attributes.empty?
  puts "There is no invalid attribute in MISP"
else
  invalid_attributes.each do |attribute|
    Cleaner.delete_with_prompt attribute
  end
end
