class Validator
  def initialize(livr_rules, is_auto_trim = false)
    @is_prepare = false
    @livr_rules = livr_rules
    @validators = {}
    @errors       = false
    @is_auto_trim = is_auto_trim
    @validator_builders = {}
  end

  def register_rules(rules)
    rules.each do |name, value|
      @validator_builders[name] = value
    end
  end

  def prepare
    return unless @is_prepare == false

    @livr_rules.each do |field, field_rules|
      field_rules = [field_rules] unless field_rules.kind_of? Array
      validators = []

      field_rules.each do |rule|
        name, args = _parse_rule(rule)
        validators.push(_build_validators(name, args))
      end
      @validators[field] = validators
    end

    @is_prepare = true
  end

  def _parse_rule(livr_rule)
    if livr_rule.kind_of? Hash
      name = livr_rule.keys[0]
      args = livr_rule[name]
      args = [args] unless args.kind_of? Array
    else
      name = livr_rule
      args = []
    end

    [name, args]
  end

  def _build_validators(name, args)
    raise "Rule [%s] not registered" % [name] unless @validator_builders.has_key?(name)
    @validator_builders[name].new(args)
  end

  def validate(data)
    prepare unless @is_prepare
    return 'FORMAT_ERROR' unless data.kind_of? Hash

    result, errors = {}, {}
    @validators.each do |field_name, validators|
      next if validators.empty?
      field_result = []

      value = data.has_key?(field_name) ? data[field_name] : nil
      validators.each do |v_cb|
        arg = result.has_key?(field_name) ? result[field_name] : value
        error_code = v_cb[arg, data, field_result]
        if error_code
          errors[field_name] = error_code
          break
        elsif not value.nil?
          result[field_name] = field_result.empty? ? value : field_result[0]
        end
      end
    end

    if errors.empty?
      @errors = nil
      return result
    else
      @errors = errors
      return false
    end
  end

  def get_errors
    @errors
  end
end