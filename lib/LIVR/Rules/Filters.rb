module Filters
  def self.trim(args)
    lambda do |value, unuse, output|
      return if value.nil? or value.eql?('') or not value.kind_of? String
      output.push(value.strip! || value)
      return nil
    end
  end

  def self.to_lc(args)
    lambda do |value, unuse, output|
      return if value.nil? or value.eql?('') or not value.kind_of? String
      output.push(value.downcase!)
      return nil
    end
  end

  def self.to_uc(args)
    lambda do |value, unuse, output|
      return if value.nil? or value.eql?('') or not value.kind_of? String
      output.push(value.upcase!)
      return nil
    end
  end

  def self.remove(args)
    chars = args.shift
    lambda do |value, unuse, output|
      return if value.nil? or value.eql?('') or not value.kind_of? String
      output.push(value.gsub(/[#{Regexp.escape(chars)}]/, ''))
      return nil
    end
  end

  def self.leave_only(args)
    chars = args.shift
    lambda do |value, unuse, output|
      return if value.nil? or value.eql?('') or not value.kind_of? String
      output.push(value.gsub(/[^#{Regexp.escape(chars)}]/, ''))
      return nil
    end
  end
end
