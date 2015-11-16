class Trim
  def initialize(args)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.strip)
    return nil
  end
end

class ToLc
  def initialize(args)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.downcase)
    return nil
  end
end

class ToUc
  def initialize(args)
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.upcase)
    return nil
  end
end

class Remove
  def initialize(args)
    @chars = args.shift
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.gsub(/[#{Regexp.escape(@chars)}]/, ''))
    return nil
  end
end

class LeaveOnly
  def initialize(args)
    @chars = args.shift
  end

  def [](value, unuse, output)
    return if value.nil? or value.eql?('') or not value.kind_of? String
    output.push(value.gsub(/[^\Q#{Regexp.escape(@chars)}\E]/, ''))
    return nil
  end
end
