class Trim
  def initialize(args)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.strip)
  end
end

class ToLc
  def initialize(args)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.downcase)
  end
end

class ToUc
  def initialize(args)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.upcase)
  end
end

class Remove
  def initialize(chars)
    @chars = chars
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.gsub(/[\Q#{@chars}\E]/, ''))
  end
end

class LeaveOnly
  def initialize(chars)
    @chars = chars
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.gsub(/[^\Q#{@chars}\E]/, ''))
  end
end
