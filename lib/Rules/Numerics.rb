require 'Utils'

class Integers
  def initialize(args)
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'NOT_INTEGER' unless value.to_s =~ /^\-?\d+$/
  end
end

class PositiveInteger
  def initialize(args)
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'NOT_POSITIVE_INTEGER' unless value.to_s =~ /^\d+$/ and value.to_i > 0
  end
end

class Decimal
  def initialize(args)
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'NOT_DECIMAL' unless value.to_s =~ /^(?:\-?(?:[0-9]+\.[0-9]+)|(?:[0-9]+))$/
  end
end

class PositiveDecimal
  def initialize(args)
  end
  
  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'NOT_POSITIVE_DECIMAL' unless value.to_s =~ /^(?:(?:[0-9]*\.[0-9]+)|(?:[1-9][0-9]*))$/
  end
end

class MaxNumber
  def initialize(args)
    @max_number = args.shift.to_f
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'TOO_HIGH' if value.to_f > @max_number
  end
end

class MinNumber
  def initialize(args)
    @min_number = args.shift.to_f
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'TOO_LOW' if value.to_f < @min_number
  end
end

class NumberBetween
  def initialize(args)
    @min_number, @max_number = args
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'TOO_LOW' if value.to_f < @min_number
    return 'TOO_HIGH' if value.to_f > @max_number
  end
end
