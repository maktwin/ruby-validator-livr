require 'LIVR/Util'

class Numerics
  def self.integers(args)
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'NOT_INTEGER' unless value.to_s =~ /^\-?\d+$/
    end
  end

  def self.positive_integer(args)
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'NOT_POSITIVE_INTEGER' unless value.to_s =~ /^\d+$/ and value.to_i > 0
    end
  end

  def self.decimal(args)
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'NOT_DECIMAL' unless value.to_s =~ /^(?:\-?(?:[0-9]+\.[0-9]+)|(?:[0-9]+))$/
    end
  end

  def self.positive_decimal(args)
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'NOT_POSITIVE_DECIMAL' unless value.to_s =~ /^(?:(?:[0-9]*\.[0-9]+)|(?:[1-9][0-9]*))$/
    end
  end

  def self.max_number(args)
    max_number = args.shift.to_f
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'TOO_HIGH' if value.to_f > max_number
    end
  end

  def self.min_number(args)
    min_number = args.shift.to_f
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'TOO_LOW' if value.to_f < min_number
    end
  end

  def self.number_between(args)
    min_number, max_number = args
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'TOO_LOW' if value.to_f < min_number
      return 'TOO_HIGH' if value.to_f > max_number
    end
  end
end
