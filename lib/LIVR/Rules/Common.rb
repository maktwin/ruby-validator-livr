module Common
  def self.required(args)
    lambda do |value, unuse, unuse_|
      return 'REQUIRED' if value.nil? or value.eql?('')
    end
  end

  def self.not_empty(args)
    lambda do |value, unuse, unuse_|
      return 'CANNOT_BE_EMPTY' if !value.nil? and value.eql?('')
    end
  end

  def self.not_empty_list(args)
    lambda do |value, unuse, unuse_|
      return 'CANNOT_BE_EMPTY' if value.eql?('') or value.nil?
      return 'WRONG_FORMAT' unless value.kind_of? Array
      return 'CANNOT_BE_EMPTY' if value.size.equal?(0)
    end
  end

  def self.any_object(args)
    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? Hash
    end
  end
end
