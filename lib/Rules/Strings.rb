class OneOf
  def initialize(args, unuse_)
    @allowed_values = allowed_values
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'NOT_ALLOWED_VALUE' unless @allowed_values.include? value
  end
end

class MaxLength
  def initialize(length, unuse_)
    @max_length = length[0].to_i
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_LONG' if value.length > @max_length
  end
end

class MinLength
  def initialize(length, unuse_)
    @min_length = length[0].to_i
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < @min_length
  end
end

class LengthEqual
  def initialize(length, unuse_)
    @length = length[0]
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < @length
    return 'TOO_LONG'  if value.length > @length
  end
end

class LengthBetween
  def initialize(length, unuse_)
    @min_length = length[0]
    @max_length = length[1]
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < @min_length
    return 'TOO_LONG'  if value.length > @max_length
  end
end

class Like
  def initialize(args, unuse_)
    re = args[0]
    is_ignore_case = args.length == 2 && args[1] === 'i'
    @re = is_ignore_case ? %r(#{re})i : %r(#{re})
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'WRONG_FORMAT' unless value =~ @re
  end
end
