class Trim
  def initialize(unuse, unuse_)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.strip)
    return nil
  end
end

class ToLc
  def initialize(unuse, unuse_)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.downcase)
    return nil
  end
end

class ToUc
  def initialize(unuse, unuse_)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.upcase)
    return nil
  end
end

class Remove
  def initialize(chars, unuse_)
    @chars = args[0]
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.gsub(/[\Q#{@chars}\E]/, ''))
    return nil
  end
end

class LeaveOnly
  def initialize(chars, unuse_)
    @chars = chars[0]
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.gsub(/[^\Q#{@chars}\E]/, ''))
    return nil
  end
end
