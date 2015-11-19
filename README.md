[![Build Status](https://travis-ci.org/maktwin/ruby-validator-livr.svg?branch=master)](https://travis-ci.org/maktwin/ruby-validator-livr)

# NAME
LIVR.Validator - Lightweight validator supporting Language Independent Validation Rules Specification (LIVR)

# SYNOPSIS
Common usage:

    require 'LIVR'
    LIVR.default_auto_trim('is_auto_trim')

    validator = LIVR.new({
      'name'      => 'required',
      'email'     => [ 'required', 'email' ],
      'gender'    => { 'one_of' => ['male', 'female'] },
      'phone'     => { 'max_length' => 10 },
      'password'  => [ 'required', {'min_length' => 10} ],
      'password2' => { 'equal_to_field' => 'password' }
    })

    valid_data = validator.validate(userData)

    if valid_data
      save_user(valid_data)
    else
      errors = validator.get_errors
    end


You can use filters separately or can combine them with validation:

    validator = LIVR.new({
      'email' => [ 'required', 'trim', 'email', 'to_lc' ]
    })

Feel free to register your own rules:

You can use aliases(prefferable, syntax covered by the specification) for a lot of cases:

    validator = LIVR.new({
      'password' => ['required', 'strong_password']
    })

    validator.register_aliased_rule({ 
      'name'  => 'strong_password',
      'rules' => {'min_length' => 6},
      'error' => 'WEAK_PASSWORD'
    })

Or you can write more sophisticated rules directly:

    validator = LIVR.new({
      'password' => ['required', 'strong_password']
    })

    validator.register_rules({
      'strong_password' => lambda do |args|
        lambda do |value, unuse, unuse_|
          return if value.nil? or value.eql?('')
          return 'WEAK_PASSWORD' if value.to_s.length < 6
        end
      end
    })

# DESCRIPTION
See ['LIVR Specification'](http://livr-spec.org) for detailed documentation and list of supported rules.

Features:

 * Rules are declarative and language independent
 * Any number of rules for each field
 * Return together errors for all fields
 * Excludes all fields that do not have validation rules described
 * Has possibility to validatate complex hierarchical structures
 * Easy to describe and undersand rules
 * Returns understandable error codes(not error messages)
 * Easy to add own rules
 * Rules are be able to change results output ("trim", "nested\_object", for example)
 * Multipurpose (user input validation, configs validation, contracts programming etc)

# INSTALL

Install LIVR from RubyGems using gem::

    gem install livr

# CLASS METHODS

## LIVR.new(livr, is_auto_trim)
Contructor creates validator objects.
livr - validations rules. Rules description is available here - https://github.com/koorchik/LIVR

is_auto_trim - asks validator to trim all values before validation. Output will be also trimmed.
if is_auto_trim is nil than default_auto_trim value will be used.

## LIVR.register_aliased_default_rule(alias)
alias - is a hash that contains: name, rules, error (optional).

    LIVR.register_aliased_default_rule({
      'name'  => 'valid_address',
      'rules' => { 'nested_object' => {
        'country' => 'required',
        'city' => 'required',
        'zip' => 'positive_integer'
      }}
    })

Then you can use "valid\_address" for validation:

    {
      'address' => 'valid_address'
    }


You can register aliases with own errors: 

    LIVR.register_aliased_default_rule({
      'name' => 'adult_age',
      'rules' => [ 'positive_integer', { 'min_number' => 18 } ],
      'error' => 'WRONG_AGE'
    })

All rules/aliases for the validator are equal. The validator does not distinguish "required", "list\_of\_different\_objects" and "trim" rules. So, you can extend validator with any rules/alias you like.

## LIVR.register_default_rules({"rule\_name" => rule_builder })
rule_builder - is a lambda function which will be called for building single rule validator.

    LIVR.register_default_rules({
      'my_rule' => lambda do |args|
        rule_builders = args.pop
        # rule_builders - are rules from original validator
        # to allow you create new validator with all supported rules
        # validator = LIVR.new(livr).register_rules(rule_builders).prepare
    
        lambda do |value, params, output|
          return "SOME_ERROR_CODE" if notValid
        end
      end
    });

Then you can use "my\_rule" for validation:
    
    {
      'name1' => 'my_rule', # Call without parameters
      'name2' => { 'my_rule': arg1 }, # Call with one parameter.
      'name3' => { 'my_rule': [arg1] }, # Call with one parameter.
      'name4' => { 'my_rule': [ arg1, arg2, arg3 ] } # Call with many parameters.
    }

Here is "max\_number" implemenation:

    max_number = lambda do |args|
      max_number = args.shift
      lambda do |value, params, output|
        # We do not validate empty fields. We have "required" rule for this purpose
        return if value.nil? or value.eql?('')
        # return error message
        return 'TOO_HIGH' if value.to_f > max_number
      end
    end
    LIVR.register_default_rules({'max_number' => max_number})

All rules for the validator are equal. The validator does not distinguish "required", "list\_of\_different\_objects" and "trim" rules. So, you can extend validator with any rules you like.

## LIVR.get_default_rules
returns object containing all default rule_builders for the validator. You can register new rule or update existing one with "register_rules" method.

## LIVR.default_auto_trim(is_auto_trim)
Enables or disables automatic trim for input data. If is on then every new validator instance will have auto trim option enabled


# OBJECT METHODS

## validator.validate(input)
Validates user input. On success returns valid_data (contains only data that has described validation rules). On error return false.

    my valida_data = validator.validate(input)

    if validData
      # use validData
    else
      errors = validator.get_errors
    end

## validator.get_errors
Returns errors object.

   {
      "field1" => "ERROR_CODE",
      "field2" => "ERROR_CODE",
        ...
    }

For example:

    {
      "country"  => "NOT_ALLOWED_VALUE",
      "zip"      => "NOT_POSITIVE_INTEGER",
      "street"   => "REQUIRED",
      "building" => "NOT_POSITIVE_INTEGER"
    }

## validator.register_rules({"rule_name": rule_builder})

rule_builder - is a lambda function which will be called for building single rule validator.

See "LIVR.register_default_rules" for rules examples.

## validator.register_aliased_rule(alias)

alias - is a composite validation rule. 

See "LIVR.register_aliased_default_rule" for rules examples.

## validator.get_rules
returns object containing all rule_builders for the validator. You can register new rule or update existing one with "register_rules" method.

# AUTHOR
koorchik (Viktor Turskyi), maktwin (Maksym Panchokha)

# BUGS
Please report any bugs or feature requests to Github https://github.com/maktwin/ruby-validator-livr

# LICENSE AND COPYRIGHT

Copyright 2012 Viktor Turskyi.

This program is free software; you can redistribute it and/or modify it under the terms of the the Artistic License (2.0). You may obtain a copy of the full license at:

http://www.perlfoundation.org/artistic_license_2_0

Any use, modification, and distribution of the Standard or Modified Versions is governed by this Artistic License. By using, modifying or distributing the Package, you accept this license. Do not use, modify, or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made by someone other than you, you are nevertheless required to ensure that your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge patent license to make, have made, use, offer to sell, sell, import and otherwise transfer the Package with respect to any patent claims licensable by the Copyright Holder that are necessarily infringed by the Package. If you institute patent litigation (including a cross-claim or counterclaim) against any party alleging that the Package constitutes direct or contributory patent infringement, then this Artistic License to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES. THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
