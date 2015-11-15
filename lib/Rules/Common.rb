class Required
  def initialize(unuse, unuse_)
  end

  def [](value, unuse, unuse_)
    'REQUIRED' if value.nil? or value.eql?('')
  end
end

class NotEmpty
  def initialize(unuse, unuse_)
  end

  def [](value, unuse, unuse_)
    'CANNOT_BE_EMPTY' if !value.nil? and value.eql?('')
  end
end

class NotEmptyList
  def initialize(unuse, unuse_)
  end
  
  def [](list, unuse, unuse_)
    return 'CANNOT_BE_EMPTY' if list.eql?('') or list.nil?
    return 'WRONG_FORMAT'    unless list.kind_of? Array
    return 'CANNOT_BE_EMPTY' if list.size.equal?(0)
  end
end
