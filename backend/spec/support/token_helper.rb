module Support
  module TokenHelper
    include Shared::UserTokenConcern

    def user_token_id(token)
      secret = Rails.application.secrets.jwt_secret
      payload, = JWT.decode(token, secret, true, algorithm: "HS256")
      payload["id"]
    end

    def token_headers(token)
      { "Authentication" => "Bearer #{token}" }
    end
  end
end

RSpec.configure do |config|
  config.include Support::TokenHelper, type: :controller
end
