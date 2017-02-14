class SessionsController < ApplicationController
  include Shared::UserTokenConcern

  def create
    params.require(:session).permit(:email, :password)
    email, password = params[:session].values_at(:email, :password)
    user = User.find_by(email: email)

    if user.try(:authenticate, password)
      render json: { success: true, token: create_user_token(user) },
        status: :created
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  before_action :authenticate_request, only: :test
  def test
    render json: {success: true, user: current_user}
  end
end
