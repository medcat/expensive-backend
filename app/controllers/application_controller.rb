class ApplicationController < ActionController::Metal
  include AbstractController::Rendering
  include ActionView::Layouts
  include ActionController::UrlFor
  include ActionController::Redirecting
  include ActionController::ApiRendering
  include ActionController::Renderers::All
  include ActionController::ConditionalGet
  include ActionController::ImplicitRender
  include ActionController::StrongParameters
  include ActionController::ForceSSL
  include ActionController::DataStreaming
  # Before callbacks should also be executed as early as possible, so
  # also include them at the bottom.
  include AbstractController::Callbacks
  # Append rescue at the bottom to wrap as much as possible.
  include ActionController::Rescue
  # Add instrumentations hooks at the bottom, to ensure they instrument
  # all the methods properly.
  include ActionController::Instrumentation
  # Params wrapper should come before instrumentation so they are
  # properly showed in logs
  include ActionController::ParamsWrapper
  include Rails.application.routes.url_helpers

  append_view_path "#{Rails.root}/app/views"
  wrap_parameters format: [:json]


  include Pundit
  include Application::AuthenticationConcern
  include Application::ErrorConcern
  include Application::MimeConcern
end
