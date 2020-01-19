class ApiController < ActionController::API
  include Authentication::HelperMethods
  include Authenticatable
end
