$LOAD_PATH << './lib'

require "DEFAULT_RULES"
require "validator"

class LIVR < Validator
  def initialize(livr_rules, is_auto_trim = false)
    super(livr_rules, is_auto_trim)
    register_rules(DEFAULT_RULES)
  end
end

# -----------TEST----------------

# livr_rules = {
#     :name  => [:required, {:leave_only => 'mak'}],
#     :phone => [:integer, {:max_length => 10}],
#     :email => [:email],
#     :url   => [:url, :required],
#     :date => [:iso_date],
#     :password => [:required, { :length_between => [5, 20] }],
#     :password2 => [{ :equal_to_field => 'password' }],
#     :gender    => {:one_of => ['male', 'female']}
# }

# data = {
#   :name  => 'maktwin',
#   :phone => '55555',
#   :email => 'm.panchoha@gmail.com',
#   :url   => 'https://localhost',
#   :date  => '2010-01-25',
#   :password  => 'password',
#   :password2 => 'password',
#   :gender    => 'male'
# }

# livr = LIVR.new(livr_rules)
# puts livr.validate(data)
# puts livr.get_errors