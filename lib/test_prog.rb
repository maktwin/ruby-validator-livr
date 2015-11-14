require './LIVR'

# -----------TEST----------------

livr_rules = {
    :name  => [:required, {:leave_only => 'mak'}],
    :phone => [:integer, {:max_length => 10}],
    :email => [:email],
    :url   => [:url, :required],
    :date => [:iso_date],
    :password => [:required, { :length_between => [5, 20] }],
    :password2 => [{ :equal_to_field => 'password' }]
}

data = {
  :name  => 'maktwin',
  :phone => '55555',
  :email => 'm.panchoha@gmail.com',
  :url   => 'https://localhost',
  :date  => '2010-01-25',
  :password => 'password',
  :password2 => 'password'
}

livr = LIVR.new(livr_rules)
puts livr.validate(data)
puts livr.get_errors