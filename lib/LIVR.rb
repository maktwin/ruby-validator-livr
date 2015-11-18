require "LIVR/Rules/Common"
require "LIVR/Rules/Filters"
require "LIVR/Rules/Numerics"
require "LIVR/Rules/Strings"
require "LIVR/Rules/Special"
require "LIVR/Rules/Helpers"

class LIVR
  @@DEFAULT_RULES = {
    'required'                  => Common.method(:required),
    'not_empty'                 => Common.method(:not_empty),
    'not_empty_list'            => Common.method(:not_empty_list),

    'trim'                      => Filters.method(:trim),
    'to_lc'                     => Filters.method(:to_lc),
    'to_uc'                     => Filters.method(:to_uc),
    'remove'                    => Filters.method(:remove),
    'leave_only'                => Filters.method(:leave_only),

    'integer'                   => Numerics.method(:integers),
    'positive_integer'          => Numerics.method(:positive_integer),
    'decimal'                   => Numerics.method(:decimal),
    'positive_decimal'          => Numerics.method(:positive_decimal),
    'max_number'                => Numerics.method(:max_number),
    'min_number'                => Numerics.method(:min_number),
    'number_between'            => Numerics.method(:number_between),

    'one_of'                    => Strings.method(:one_of),
    'max_length'                => Strings.method(:max_length),
    'min_length'                => Strings.method(:min_length),
    'length_equal'              => Strings.method(:length_equal),
    'length_between'            => Strings.method(:length_between),
    'like'                      => Strings.method(:like),

    'email'                     => Special.method(:email),
    'url'                       => Special.method(:url),
    'iso_date'                  => Special.method(:iso_date),
    'equal_to_field'            => Special.method(:equal_to_field),

    'nested_object'             => Helpers.method(:nested_object),
    'list_of'                   => Helpers.method(:list_of),
    'list_of_objects'           => Helpers.method(:list_of_objects),
    'list_of_different_objects' => Helpers.method(:list_of_different_objects)
  }

  def initialize(livr_rules, is_auto_trim = false)
    @is_prepare = false
    @livr_rules = livr_rules
    @validators = {}
    @errors       = false
    @is_auto_trim = is_auto_trim
    @validator_builders = {}

    register_rules(@@DEFAULT_RULES)
    self
  end

  def register_rules(rules)
    rules.each do |rule_name, rule_builder|
      raise "RULE_BUILDER [%s] SHOULD BE A CODEREF" % rule_name unless rule_builder.respond_to? :call
      @validator_builders[rule_name] = rule_builder
    end
    self
  end

  def register_aliased_rule(alias_hash)
    raise 'Alias name required' if alias_hash['name'].nil?
    @validator_builders[alias_hash['name']] = _build_aliased_rule(alias_hash)
    self
  end

  def self.register_default_rules(rules)
    rules.each do |rule_name, rule_builder|
      raise "RULE_BUILDER [%s] SHOULD BE A CODEREF" % rule_name unless rule_builder.respond_to? :call
      @@DEFAULT_RULES[rule_name] = rule_builder
    end
    self
  end

  def self.register_aliased_default_rule(alias_hash)
    raise 'Alias name required' if alias_hash['name'].nil?
    @@DEFAULT_RULES[alias_hash['name']] = _build_aliased_rule(alias_hash)
    self
  end

  def prepare
    return unless @is_prepare == false

    @livr_rules.each do |field, field_rules|
      field_rules = [field_rules] unless field_rules.kind_of? Array
      validators = []

      field_rules.each do |rule|
        name, args = _parse_rule(rule)
        validators.push(_build_validator(name, args))
      end
      @validators[field] = validators
    end

    @is_prepare = true
    self
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

  def _build_validator(name, args)
    raise "Rule [%s] not registered" % [name] unless @validator_builders.has_key?(name)

    allArgs = args
    allArgs.push(get_rules)
    @validator_builders[name].call(allArgs)
  end

  def _build_aliased_rule(alias_hash)
    raise 'Alias name required'  if alias_hash['name'].nil?
    raise 'Alias rules required' if alias_hash['rules'].nil?

    livr = {:value => alias_hash['rules']}
    lambda do |args|
      rule_builders = args.pop
      validator = LIVR.new(livr).register_rules(rule_builders).prepare
      lambda do |value, unuse, output|
        result = validator.validate({:value => value})
        if result
          output.push(result[:value])
          return
        else
          validator_errors = validator.get_errors
          return alias_hash['error'] || validator_errors[:value]
        end
      end
    end
  end

  def validate(data)
    prepare unless @is_prepare
    unless data.kind_of? Hash
      @errors = 'FORMAT_ERROR'
      return
    end

    data = _auto_trim(data) if @is_auto_trim
    result, errors = {}, {}
    @validators.each do |field_name, validators|
      next if validators.empty?
      field_result = []
      value = data.has_key?(field_name) ? data[field_name] : nil
      validators.each do |v_cb|
        arg = result.has_key?(field_name) ? result[field_name] : value
        error_code = v_cb.call(arg, data, field_result)
        if error_code
          errors[field_name] = error_code
          break
        elsif data.has_key?(field_name)
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

  def get_rules
    @validator_builders
  end

  def get_errors
    @errors
  end

  def self.get_default_rules
    @@DEFAULT_RULES
  end

  def _auto_trim(data)
    if data.kind_of? String
      data.strip!
      return data
    elsif data.kind_of? Hash
      trimmed_data = {}
      data.each do |key, value|
        trimmed_data[key] = _auto_trim(value)
      end
      return trimmed_data
    elsif data.kind_of? Array
      trimmed_data = []
      data.each do |value|
        trimmed_data << _auto_trim(value)
      end
      return trimmed_data
    end

    return data
  end
end