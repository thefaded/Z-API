class ClientCreationForm
  include ActiveModel::Model

  CLIENT_ATTRIBUTES = %i[
    first_name
    last_name
    email
    phone
    gender
    password
    password_confirmation
  ].freeze

  attr_reader :creator

  CLIENT_ATTRIBUTES.each { |attribute_name| attr_accessor attribute_name }

  def initialize(params = {}, creator = nil)
    super(params)

    @creator = creator
  end

  def save
    return invalidate_form unless user.valid?

    user.save!
    send_email
    true
  rescue ActiveRecord::ActiveRecordError
    false
  end

  def user
    @user ||= User.new(client_params.merge(role: :client, created_by_id: creator&.id))
  end

  private

  def invalidate_form
    user.errors.each { |field, error| errors.add(field, error) }
    false
  end

  def client_params
    CLIENT_ATTRIBUTES.each_with_object({}) { |attribute_name, h| h[attribute_name] = send(attribute_name) }
  end

  def send_email
    UserMailer.delay.welcome_client(user.id)
  end
end
