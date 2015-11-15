require './LIVR'

# -----------TEST----------------

livr_rules = {
    :name  => [ { :required => [] } ],
    :phone => [:integer, {:max_length => 10}],
    :email => [:email],
    :url   => [:url, :required],
    :date => [:iso_date],
    :password => [:required, { :length_between => [5, 20] }],
    :password2 => [{ :equal_to_field => 'password' }],
    :address => {:nested_object => {
        :city => [:required],
        :zip => [:required, :positive_integer]
    }},
    :product_ids => [{
      :list_of => [:required, :positive_integer],
    }],
    :products => [ :not_empty_list, { :list_of_objects => {
      :product_id => [:required, :positive_integer],
      :quantity => [:required, :positive_integer]
    }}],
    :products_list => [:required, { :list_of_different_objects => [
    :product_type, 
    {
      :material => {
        :product_type => :required,
        :material_id => [:required, :positive_integer],
        :quantity => [:required, {:min_number => 1} ],
        :warehouse_id => :positive_integer
      },
      :service => {
        :product_type => :required,
        :name => [:required, {:max_length => 20} ]
      }
    }
  ]}]
}

data = {
  :name  => 'maktwin',
  :phone => '55555',
  :email => 'm.panchoha@gmail.com',
  :url   => 'https://localhost',
  :date  => '2010-01-25',
  :password => 'password',
  :password2 => 'password',
  :address => {
    :city => 'Kyiv',
    :zip => 4545
  },
  :product_ids =>[234234, 345, 3566],
  :products => [{
    :product_id => 3455,
    :quantity => 2
  },{
    :product_id => 3456,
    :quantity => 3
  }],
  :products_list => [{
    :product_type => :material,
    :material_id => 345,
    :quantity =>  5,
    :warehouse_id => 43
  },{
    :product_type => :service,
    :name => 'Clean filter'
  }]
}

livr = LIVR.new(livr_rules)
puts livr.validate(data)
puts livr.get_errors