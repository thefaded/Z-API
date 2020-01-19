class PhoneNumberValidator < ActiveModel::EachValidator
  PHONE_PATTERN = /^(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}$/i.freeze

  def validate_each(record, attribute, value)
    return if value.blank?
    return if value =~ PHONE_PATTERN

    record.errors[attribute] << (options[:message] || 'is not valid')
  end
end
