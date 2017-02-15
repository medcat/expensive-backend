module Shared
  module UserTokenConcern
    def create_user_token(user, expires: 1.day.from_now)
      expires = expires.utc.to_i
      issued = 1.second.ago.utc.to_i
      payload = {id: user.id, exp: expires, nbf: issued, iat: issued}
      secret = Rails.application.secrets.jwt_secret
      JWT.encode(payload, secret, "HS256")
    end
  end
end
