class ApplicationController < ActionController::API
  setup_renderer!
  include Pundit
  include Application::AuthenticationConcern
  include Application::ErrorConcern
  include Application::MimeConcern
end
