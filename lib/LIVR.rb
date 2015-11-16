require "LIVR/Rules/Common"
require "LIVR/Rules/Filters"
require "LIVR/Rules/Numerics"
require "LIVR/Rules/Strings"
require "LIVR/Rules/Special"
require "LIVR/Rules/Helpers"

class LIVR
  @@DEFAULT_RULES = {
    'required'                  => Required,
    'not_empty'                 => NotEmpty,
    'not_empty_list'            => NotEmptyList,

    'trim'                      => Trim,
    'to_lc'                     => ToLc,
    'to_uc'                     => ToUc,
    'remove'                    => Remove,
    'leave_only'                => LeaveOnly,

    'integer'                   => Integers,
    'positive_integer'          => PositiveInteger,
    'decimal'                   => Decimal,
    'positive_decimal'          => PositiveDecimal,
    'max_number'                => MaxNumber,
    'min_number'                => MinNumber,
    'number_between'            => NumberBetween,

    'one_of'                    => OneOf,
    'max_length'                => MaxLength,
    'min_length'                => MinLength,
    'length_equal'              => LengthEqual,
    'length_between'            => LengthBetween,
    'like'                      => Like,

    'email'                     => Email,
    'url'                       => Url,
    'iso_date'                  => IsoDate,
    'equal_to_field'            => EqualToField,

    'nested_object'             => NestedObject,
    'list_of'                   => ListOf,
    'list_of_objects'           => ListOfObjects,
    'list_of_different_objects' => ListOfDifferentObjects
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
    rules.each do |name, value|
      @validator_builders[name] = value
    end
    self
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

  def _build_validators(name, args)
    raise "Rule [%s] not registered" % [name] unless @validator_builders.has_key?(name)

    allArgs = args
    allArgs.push(get_rules)
    @validator_builders[name].new(allArgs)
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
        error_code = v_cb[arg, data, field_result]
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