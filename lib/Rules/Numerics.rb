require './Utils'

class Integers
  def initialize(unuse, unuse_)
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'NOT_INTEGER' unless value.to_s =~ /^\-?\d+$/
  end
end

class PositiveInteger
  def initialize(unuse, unuse_)
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'NOT_POSITIVE_INTEGER' unless value.to_s =~ /^\d+$/ and value.to_i > 0
  end
end

class Decimal
  def initialize(unuse, unuse_)
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'NOT_DECIMAL' unless value.to_s =~ /^\-?[\d.]+$/ and value.kind_of? Numeric
  end
end

class PositiveDecimal
  def initialize(unuse, unuse_)
  end
  
  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'NOT_POSITIVE_DECIMAL' unless value.to_s =~ /^\-?[\d.]+$/ and value.kind_of? Numeric and value > 0
  end
end

class MaxNumber
  def initialize(number, unuse_)
    @max_number = number[0].to_f
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'TOO_HIGH' if value.to_f > @max_number
  end
end

class MinNumber
  def initialize(number, unuse_)
    @min_number = number[0].to_f
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'TOO_LOW' if value.to_f < @min_number
  end
end

class NumberBetween
  def initialize(numbers, unuse_)
    @min_number = min_number[0].to_f
    @max_number = max_number[1].to_f
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless Utils.is_string_or_number?(value)
    return 'TOO_LOW' if value.to_f < min_number
    return 'TOO_HIGH' if value.to_f > max_number
  end
end
