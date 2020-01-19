require 'base64'

module AuthHelpers
  def basic_auth(email, password)
    login = Base64.encode64("#{email}:#{password}")

    { 'HTTP_AUTHORIZATION' => "Basic #{login}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers
end
