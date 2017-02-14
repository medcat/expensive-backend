# encoding: utf-8

module Application
  module AuthenticationConcern
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
end
