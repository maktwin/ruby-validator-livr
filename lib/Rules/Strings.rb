class OneOf
  def initialize(*allowed_values)
    @allowed_values = allowed_values[0]
    unless @allowed_values.kind_of? Array
      @allowed_values.pop
    end
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'NOT_ALLOWED_VALUE' unless @allowed_values.include? value
  end
end

class MaxLength
  def initialize(max_length)
    @max_length = max_length[0].to_i
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_LONG' if value.length > @max_length
  end
end

class MinLength
  def initialize(min_length)
    @min_length = min_length
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < @min_length
  end
end

class LengthEqual
  def initialize(length)
    @length = length
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < @length
    return 'TOO_LONG'  if value.length > @length
  end
end

class LengthBetween
  def initialize(min_length, max_length)
    @min_length = min_length
    @max_length = max_length
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < min_length
    return 'TOO_LONG'  if value.length > max_length
  end
end

class Like
  def initialize(args)
    re = args[0]
    is_ignore_case = args.length == 2 && args[1] === 'i'
    @re = is_ignore_case ? %r(#{re})i : %r(#{re})
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'WRONG_FORMAT' unless value =~ @re
  end
end
