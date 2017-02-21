require 'test_helper'

class RulesRegistrationTest < Minitest::Test
  def setup
    LIVR.register_default_rules({
      'strong_password' => lambda do |args|
        lambda do |value, unuse, unuse_|
          return if value.nil? or value.eql?('')
          return 'WEAK_PASSWORD' if value.to_s.length < 6
        end
      end
    })

    @validator = LIVR.new({
      'code'       => 'alphanumeric',
      'password'   => 'strong_password',
      'address'    => { 'nested_object' => {
        'street'   => 'alphanumeric',
        'password' => 'strong_password'
      }}
    })

    @validator.register_rules({
      'alphanumeric' => lambda do |args|
        lambda do |value, unuse, unuse_|
          return if value.nil? or value.eql?('')
          return 'NOT_ALPHANUMERIC' unless value =~ /^[a-z0-9]+$/
        end
      end
    })
  end

  def test_rules_registration
    default_rules = LIVR.get_default_rules
    assert(default_rules['strong_password'].respond_to?(:call), 'Default rules should contain "strong_password" rule')
    assert(!default_rules['alphanumeric'].respond_to?(:call), 'Default rules should not contain "alphanumeric" rule')

    rules = @validator.get_rules
    assert(rules['strong_password'].respond_to?(:call), 'Validator rules should contain "strong_password" rule')
    assert(rules['alphanumeric'].respond_to?(:call), 'Validator rules should contain "alphanumeric" rule')

    output = @validator.validate({
      'code' => '!qwe',
      'password' => 123,
      'address' => {
        'street'   => 'Some Street!',
        'password' => 'qwer'
      }
    })

    assert(!output, 'should return false due to validation errors')
    assert_equal(@validator.get_errors, 
      {
        'code'      =>'NOT_ALPHANUMERIC',
        'password'  => 'WEAK_PASSWORD',
        'address'   => {
          'street'   => 'NOT_ALPHANUMERIC',
          'password' => 'WEAK_PASSWORD'
        }
      }, 'Should contain error codes'
    )
  end
end