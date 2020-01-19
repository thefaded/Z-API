ActiveAdmin.register User do # rubocop:disable Metrics/BlockLength
  actions :all, except: %i[new create destroy]

  action_item :create, only: %i[index] do
    link_to 'Create new employee', create_employee_form_admin_users_path
  end

  collection_action :create_employee_form, method: :get, title: 'Create employee' do
    @employee_form ||= ::Admin::EmployeeCreationForm.new({}, current_user)
    render :creation_employee_form
  end

  collection_action :create_employee, method: :post, title: 'Create employee' do
    sanitized_params = params.require(:admin_employee_creation_form)
                             .permit(*::Admin::EmployeeCreationForm::EMPLOYEE_ATTRIBUTES)

    @employee_form = ::Admin::EmployeeCreationForm.new(sanitized_params, current_user)
    if @employee_form.save
      redirect_to admin_user_path(@employee_form.user), alert: 'The employee has been created!'
    else
      render :creation_employee_form, layout: 'active_admin'
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    inputs :email, :phone, :gender

    actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :full_name
    column :phone
    column :gender
    column :created_at
    column :last_sign_in_at
    column :role
    column :admin
    actions
  end

  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :role, :phone, :gender, :admin]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
