class OneOf
  def initialize(args)
    if args[0].kind_of? Array
      @allowed_values = args.shift
    else
      args.pop              # pop rule_builders
      @allowed_values = args
    end
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'NOT_ALLOWED_VALUE' unless @allowed_values.include? value
  end
end

class MaxLength
  def initialize(args)
    @max_length = args.shift.to_i
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_LONG' if value.length > @max_length
  end
end

class MinLength
  def initialize(args)
    @min_length = args.shift.to_i
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < @min_length
  end
end

class LengthEqual
  def initialize(args)
    @length = args.shift.to_i
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < @length
    return 'TOO_LONG'  if value.length > @length
  end
end

class LengthBetween
  def initialize(args)
    args.pop                # pop rule_builders
    @min_length = args[0]
    @max_length = args[1]
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'FORMAT_ERROR' unless value.kind_of? String
    return 'TOO_SHORT' if value.length < @min_length
    return 'TOO_LONG'  if value.length > @max_length
  end
end

class Like
  def initialize(args)
    args.pop                # pop rule_builders
    re = args[0]
    is_ignore_case = args.length == 2 && args[1] === 'i'
    @re = is_ignore_case ? %r(#{re})i : %r(#{re})
  end

  def [](value, unuse, unuse_)
    return if value.nil? or value.eql?('')
    return 'WRONG_FORMAT' unless value =~ @re
  end
end
