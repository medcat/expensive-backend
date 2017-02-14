class SessionsController < ApplicationController
  def create
    params.require(:session).permit(:email, :password)
    email, password = params[:session].values_at(:email, :password)
    user = User.find_by(email: email)

    if user.try(:authenticate, password)
      render json: { success: true, token: create_token(user) }, status: :created
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  before_action :authenticate_request, only: :test
  def test
    render json: {success: true, user: current_user}
  end

private

  def create_token(user)
    expires = 1.day.from_now.utc.to_i
    issued = Time.now.utc.to_i
    payload = {id: user.id, "exp" => expires, "nbf" => issued, "iat" => issued}
    secret = Rails.application.secrets.jwt_secret
    JWT.encode(payload, secret, "HS256")
  end
end
