$LOAD_PATH << '.'

require "DEFAULT_RULES"
require "validator"

class LIVR < Validator
  def initialize(livr_rules, is_auto_trim = false)
    super(livr_rules, is_auto_trim)
    register_rules(DEFAULT_RULES)
  end
end

# -----------TEST----------------

livr_rules = {
    :name  => [:required, {:max_length => 10}],
    :phone => [:integer, {:max_length => 10}],
}

data = {
  :name  => 'maktwin',
  :phone => '55555'
}

livr = LIVR.new(livr_rules)
puts livr.validate(data)
puts livr.get_errors