class Admin::EmployeeCreationForm
  include ActiveModel::Model

  EMPLOYEE_ATTRIBUTES = %i[
    first_name
    last_name
    email
    phone
    gender
    password
    password_confirmation
  ].freeze

  attr_reader :creator, :reset_password_token
  private :reset_password_token

  EMPLOYEE_ATTRIBUTES.each { |attribute_name| attr_accessor attribute_name }

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

  # Add logic what employee might be a client and also registered
  def user
    @user ||= begin
      user = User.new(employee_params.merge(role: :employee, created_by_id: creator&.id))

      if password.blank?
        @reset_password_token = set_password_and_reset_token(user)
      end
      user
    end
  end

  private

  def invalidate_form
    user.errors.each { |field, error| errors.add(field, error) }
    false
  end

  def employee_params
    EMPLOYEE_ATTRIBUTES.each_with_object({}) { |attribute_name, h| h[attribute_name] = send(attribute_name) }
  end

  def set_password_and_reset_token(obj)
    obj.password = Devise.friendly_token
    obj.password_confirmation = obj.password

    raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
    obj.reset_password_token = hashed_token
    obj.reset_password_sent_at = Time.now.utc

    raw_token
  end

  def send_email
    UserMailer.delay.welcome_employee(user.id, reset_password_token)
  end
end
