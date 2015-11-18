require 'LIVR'

module Helpers
  def self.nested_object(args)
    livr, rule_builders = args
    validator = LIVR.new(livr).register_rules(rule_builders).prepare

    lambda do |nested_obj, unuse, output|
      return if nested_obj.nil? or nested_obj.eql?('')
      return 'FORMAT_ERROR' unless nested_obj.kind_of? Hash

      result = validator.validate(nested_obj)
      if result
        output.push(result)
        return
      else
        return validator.get_errors
      end
    end
  end

  def self.list_of(args)
    if args[0].kind_of? Array
      rules, rule_builders = args
    else
      rule_builders = args.pop
      rules = args
    end
    livr = {:field => rules}
    validator = LIVR.new(livr).register_rules(rule_builders).prepare

    lambda do |values, unuse, output|
      return if values.nil? or values.eql?('')
      return 'FORMAT_ERROR' unless values.kind_of? Array

      results, errors = [], []
      values.each do |val|
        result = validator.validate({:field => val})
        if result
          results.push(result[:field])
          errors.push(nil)
        else
          results.push(nil)
          validatorErrors = validator.get_errors
          errors.push(validatorErrors[:field])
        end
      end

      if errors.any?
        return errors
      else
        output.push(results)
        return
      end
    end
  end

  def self.list_of_objects(args)
    livr, rule_builders = args
    validator = LIVR.new(livr).register_rules(rule_builders).prepare

    lambda do |objects, unuse, output|
      return if objects.nil? or objects.eql?('')
      return 'FORMAT_ERROR' unless objects.kind_of? Array

      results, errors = [], []
      objects.each do |obj|
        result = validator.validate(obj)

        if result
          results.push(result)
          errors.push(nil)
        else
          results.push(nil)
          errors.push(validator.get_errors)
        end
      end
      if errors.any?
        return errors
      else
        output.push(results)
        return
      end
    end
  end

  def self.list_of_different_objects(args)
    selector_field, livrs, rule_builders = args

    validators = {}
    livrs.each do |selector_value, livr|
      validator = LIVR.new(livr).register_rules(rule_builders).prepare
      validators[selector_value] = validator
    end

    lambda do |objects, unuse, output|
      return if objects.nil? or objects.eql?('')
      return 'FORMAT_ERROR' unless objects.kind_of? Array

      results, errors = [], []
      objects.each do |obj|
        if not obj.kind_of? Hash or obj[selector_field].nil? or validators[obj[selector_field]].nil?
          errors.push('FORMAT_ERROR')
          next
        end

        validator = validators[obj[selector_field]]
        result = validator.validate(obj)
        if result
          results.push(result)
          errors.push(nil)
        else
          results.push(nil)
          errors.push(validator.get_errors)
        end
      end

      if errors.any?
        return errors
      else
        output.push(results)
        return
      end
    end
  end
end