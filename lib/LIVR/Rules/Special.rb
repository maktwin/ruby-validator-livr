require 'uri'
require 'date'
require 'LIVR/Util'

module Special
  def self.email(args)
    email_re = %r(^([\w\-+]+(?:\.[\w\-+]+)*)@((?:[\w\-]+\.)*\w[\w\-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)i

    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? String

      return 'WRONG_EMAIL' unless value =~ email_re
      return 'WRONG_EMAIL' if value =~ %r(\@.*\@)
      return 'WRONG_EMAIL' if value =~ %r(\@.*_)
    end
  end

  def self.url(args)
    url_re = %r(\A(http|https):\/\/([a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}|(25[0-5]|2[0-4]\d|[0-1]?\d?\d)
      (\.(25[0-5]|2[0-4]\d|[0-1]?\d?\d)){3}|localhost)(:[0-9]{1,5})?(\/.*)?\z)ix

    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? String
      return 'WRONG_URL' unless value =~ url_re
    end
  end

  def self.iso_date(args)
    date_re = %r(^(\d{4})-(\d{2})-(\d{2})$)

    lambda do |value, unuse, unuse_|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless value.kind_of? String
      return 'WRONG_DATE'   unless value =~ date_re
      begin
        DateTime.strptime(value, '%F')
        return nil
      rescue
        return 'WRONG_DATE'
      end
    end
  end

  def self.equal_to_field(args)
    field = args.shift

    lambda do |value, params, unuse|
      return if value.nil? or value.eql?('')
      return 'FORMAT_ERROR' unless Util.is_string_or_number?(value)
      return 'FIELDS_NOT_EQUAL' unless value == params[field]
    end
  end
end