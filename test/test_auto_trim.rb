require 'minitest/autorun'
require 'LIVR'

class LIVRAutoTrimTest < Minitest::Test
  def setup
    @validator = LIVR.new({
      'code'     => 'required',
      'password' => ['required', { 'min_length' => 3 }],
      'address'  => { 'nested_object' => {
        'street' => { 'min_length' => 5 },
      }}
    }, 'is_auto_trim')
  end

  def test_auto_trim_negative
    output = @validator.validate({
      'code'     => '  ',
      'password' => ' 12  ',
      'address'  => {
        'street' => '  happ '
      }
    })

    assert(!output, 'should return false due to validation errors fot trimmed values')
    assert_equal(@validator.get_errors,
      {
        'code'     =>'REQUIRED',
        'password' => 'TOO_SHORT',
        'address'  => {
          'street'   => 'TOO_SHORT',
        }
      }, 'Should contain error codes'
    )
  end

  def test_auto_trim_positive
    output = @validator.validate({
      'code'     => ' A ',
      'password' => ' 123  ',
      'address'  => {
        'street' => '  hello '
      }
    })

    assert(!@validator.get_errors, 'Validator should contain no errors')
    assert_equal(output,
      {
        'code'     =>'A',
        'password' => '123',
        'address'  => {
          'street' => 'hello',
        }
      }, 'Should contain trimmed data'
    )
  end
end