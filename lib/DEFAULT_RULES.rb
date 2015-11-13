$LOAD_PATH << './Rules'

require "Common"
require "Filters"
require "Numerics"
require "Strings"

DEFAULT_RULES = {
  :required         => Required,
  :not_empty        => NotEmpty,
  :not_empty_list   => NotEmptyList,

  :trim             => Trim,
  :to_lc            => ToLc,
  :to_uc            => ToUc,
  :remove           => Remove,
  :leave_only       => LeaveOnly,

  :integer          => Integers,
  :positive_integer => PositiveInteger,
  :decimal          => Decimal,
  :positive_decimal => PositiveDecimal,
  :max_number       => MaxNumber,
  :min_number       => MinNumber,
  :number_between   => NumberBetween,

  :one_of           => OneOf,
  :max_length       => MaxLength,
  :min_length       => MinLength,
  :length_equal     => LengthEqual,
  :length_between   => LengthBetween,
  :like             => Like
}
