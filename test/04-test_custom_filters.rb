require 'test_helper'

class CustomFiltersTest < Minitest::Test
  def setup
    LIVR.register_default_rules({
      'my_ucfirst' => lambda do |args|
        lambda do |value, unuse, output|
          return if value.nil? or value.eql?('')
          output.push(value.capitalize!)
          return nil
        end
      end,
      'my_lc' => lambda do |args|
        lambda do |value, unuse, output|
          return if value.nil? or value.eql?('')
          output.push(value.downcase)
          return nil
        end
      end
    })
  end

  def test_custom_filters
    validator = LIVR.new({
      'word1' => ['my_lc', 'my_ucfirst'],
      'word2' => ['my_lc'],
      'word3' => ['my_ucfirst'],
    })

    output = validator.validate({
      'word1' => 'wordOne',
      'word2' => 'wordTwo',
      'word3' => 'wordThree',
    })

    assert_equal(output,
      {
        'word1' => 'Wordone',
        'word2' => 'wordtwo',
        'word3' => 'Wordthree',
      }, 'Should apply changes to values'
    )
  end
end