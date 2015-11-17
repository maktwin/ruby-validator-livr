require 'minitest/autorun'
require 'LIVR'

class LIVRTest < Minitest::Test
  def setup
    @validator = LIVR.new({
      'code'     => 'required',
      'password' => ['required', { 'min_length' => 3 }],
      'address'  => { 'nested_object' => {
        'street' => { 'min_length' => 5 },
      }}
    }, 'is_auto_trim')
  end

  def test_negative
    output = @validator.validate({
      'code' => '  ',
      'password' => ' 12  ',
      'address' => {
        'street' => '  happy '
      }
    })

    assert(!output, 'should return false due to validation errors fot trimmed values')
    assert_equal({
        'code'     =>'REQUIRED',
        'password' => 'TOO_SHORT',
        'address'  => {
          'street'   => 'TOO_SHORT',
        }
      }, validator.get_errors, 'Should contain error codes'
    )
  end
end