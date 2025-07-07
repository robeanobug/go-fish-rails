RSpec.configure do |config|
  # Make it load Devise helpers for controller, system tests so you can sign in users
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system

  # Remove when https://github.com/heartcombo/devise/issues/5705 resolve
  config.before(:each, type: :system) do
    Rails.application.reload_routes_unless_loaded
  end
end