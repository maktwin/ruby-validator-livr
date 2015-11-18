require "test_helper"

class LIVRTest < Minitest::Test
  def test_livr_positive
    iterate_test_data(
      'test_suite/positive',
      lambda do |data|
        validator = LIVR.new(data['rules'])
        output = validator.validate(data['input'])

        assert(!validator.get_errors, 'Validator should contain no errors')
        assert_equal(output, data['output'], 'Validator should return validated data')
      end
    )
  end

  def test_livr_negative
    iterate_test_data(
      'test_suite/negative',
      lambda do |data|
        validator = LIVR.new(data['rules'])
        output = validator.validate(data['input'])

        assert(!output, 'Validator should return false')
        assert_equal(data['errors'], validator.get_errors, 'Validator should contain valid errors')
      end
    )
  end

  def test_aliases_positive
    iterate_test_data(
      'test_suite/aliases_positive',
      lambda do |data|
        validator = LIVR.new(data['rules'])
        data['aliases'].each do |alias_hash|
          validator.register_aliased_rule(alias_hash)
        end
        output = validator.validate(data['input'])

        assert(!validator.get_errors, 'Validator should contain no errors')
        assert_equal(output, data['output'], 'Validator should return validated data')
      end
    )
  end

  def test_aliases_negative
    iterate_test_data(
      'test_suite/aliases_negative',
      lambda do |data|
        validator = LIVR.new(data['rules'])
        data['aliases'].each do |alias_hash|
          validator.register_aliased_rule(alias_hash)
        end
        output = validator.validate(data['input'])

        assert(!output, 'Validator should return false')
        assert_equal(validator.get_errors, data['errors'], 'Validator should contain valid errors')
      end
    )
  end

  def iterate_test_data(dir_basename, cb)
    dir_fullname = "#{File.dirname(__FILE__)}/#{dir_basename}"
    test_dirs = Dir["#{dir_fullname}/*"].sort!
    test_dirs.each do |test_dir|
      data = {}
      Dir["#{test_dir}/*.json"].each do |test_data|
        key_data    = File.basename(test_data, ".json")
        plain_data  = File.read(test_data)
        parsed_data = JSON.parse(plain_data)

        data[key_data] = parsed_data
      end
      cb.call(data)
    end
  end
end