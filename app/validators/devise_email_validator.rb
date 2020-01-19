class DeviseEmailValidator < ActiveModel::EachValidator
  DEFAULT_OPTIONS = { regexp: Devise.email_regexp }.freeze

  def validate_each(record, attribute, value)
    return if value.blank?
    return if value =~ DEFAULT_OPTIONS[:regexp]

    record.errors[attribute] << (options[:message] || 'is not valid')
  end
end
