Rails.application.routes.default_url_options = {
  host: ENV["HOST"] || "localhost",
  format: :json
}
