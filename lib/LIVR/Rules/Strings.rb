require 'LIVR/Util'

module Strings
  def self.one_of(args)
    if args[0].kind_of? Array
      allowed_values = args.shift
    else
      args.pop              # pop rule_builders
      allowed_values = args
    end

    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? String
      return 'NOT_ALLOWED_VALUE' unless allowed_values.include? value
    end
  end

  def self.max_length(args)
    max_length = args.shift.to_i

    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? String
      return 'TOO_LONG' if value.length > max_length
    end
  end

  def self.min_length(args)
    min_length = args.shift.to_i
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? String
      return 'TOO_SHORT' if value.length < min_length
    end
  end

  def self.length_equal(args)
    length = args.shift.to_i
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? String
      return 'TOO_SHORT' if value.length < length
      return 'TOO_LONG'  if value.length > length
    end
  end

  def self.length_between(args)
    min_length, max_length = args

    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? String
      return 'TOO_SHORT' if value.length < min_length
      return 'TOO_LONG'  if value.length > max_length
    end
  end

  def self.like(args)
    args.pop                # pop rule_builders
    re = args[0]
    is_ignore_case = args.length == 2 && args[1] == 'i'
    re = is_ignore_case ? %r(#{re})i : %r(#{re})

    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'WRONG_FORMAT' unless value =~ re
    end
  end
end
