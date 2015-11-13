module Utils
  def Utils.is_string_or_number?(value)
    return true if value.kind_of? Numeric or value.kind_of? String
    return false
  end
end