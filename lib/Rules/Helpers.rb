require 'LIVR'

class NestedObject
  def initialize(rules, rule_builders)
    livr = rules[0]
    @validator = LIVR.new(livr).register_rules(rule_builders).prepare
  end

  def [](nested_obj, unuse, output)
    return if nested_obj.nil? or nested_obj.eql?('')
    return 'FORMAT_ERROR' unless nested_obj.kind_of? Hash

    result = @validator.validate(nested_obj)
    if result
      output = result
      return
    else
      return @validator.get_errors
    end
  end
end

class ListOf
  def initialize(livr, rule_builders)
    @validator = LIVR.new({:field => livr}).register_rules(rule_builders).prepare
  end

  def [](values, unuse, output)
    return if values.nil? or values.eql?('')
    return 'FORMAT_ERROR' unless values.kind_of? Array

    results, errors = [], []
    values.each do |val|
      result = @validator.validate({:field => val})
      if result
        results.push(result[:field])
        errors.push(nil)
      else
        results.push(nil)
        validatorErrors = @validator.get_errors
        errors.push(validatorErrors[:field])
      end
    end

    if errors.any?
      return errors
    else
      output = results
      return
    end
  end
end

class ListOfObjects
  def initialize(rules, rule_builders)
    livr = rules[0]
    @validator = LIVR.new(livr).register_rules(rule_builders).prepare
  end

  def [](objects, unuse, output)
    return if objects.nil? or objects.eql?('')
    return 'FORMAT_ERROR' unless objects.kind_of? Array

    results, errors = [], []
    objects.each do |obj|
      result = @validator.validate(obj)

      if result
        results.push(result)
        errors.push(nil)
      else
        results.push(nil)
        errors.push(@validator.get_errors)
      end
    end

    if errors.any?
      return errors
    else
      output = results
      return
    end
  end
end

class ListOfDifferentObjects
  def initialize(args, rule_builders)
    @selector_field = args[0]
    livrs           = args[1]

    @validators = {}
    livrs.each do |selector_value, livr|
      validator = LIVR.new(livr).register_rules(rule_builders).prepare
      @validators[selector_value] = validator
    end
  end

  def [](objects, unuse, output)
    return if objects.nil? or objects.eql?('')
    return 'FORMAT_ERROR' unless objects.kind_of? Array

    results, errors = [], []
    objects.each do |obj|
      if not obj.kind_of? Hash or obj[@selector_field].nil? or @validators[obj[@selector_field]].nil?
        errors.push('FORMAT_ERROR')
        next
      end

      validator = @validators[obj[@selector_field]]
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
      output = results
      return
    end
  end
end