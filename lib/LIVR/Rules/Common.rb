class Common
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
    lambda do |list, unuse, unuse_|
      return 'CANNOT_BE_EMPTY' if list.eql?('') or list.nil?
      return 'WRONG_FORMAT'    unless list.kind_of? Array
      return 'CANNOT_BE_EMPTY' if list.size.equal?(0)
    end
  end
end
