class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

private

  TOKEN_REGEX = /\A(?:Token|Bearer|token|bearer)\s+(.*)\z/
  def authenticate_request
    header = request.authorization || fail
    token = header.match(TOKEN_REGEX)[1] || fail
    secret = Rails.application.secrets.jwt_secret
    payload, = JWT.decode(token, secret, true, algorithm: "HS256")
    @current_user = User.find(payload["id"]) || fail
  rescue
    headers["WWW-Authenticate"] = "Bearer realm=\"Application\""
    render json: { success: false }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
