class API::SessionsController < ApplicationController
  include Shared::UserTokenConcern
  before_action :authenticate_request, only: [:renew]

  def create
    params.require(:session).permit(:email, :password)
    email, password = params[:session].values_at(:email, :password)
    user = User.find_by(email: email)

    if user.try(:authenticate, password)
      token = create_user_token(user)
      render json: { token: token }, status: :created
    else
      head :unauthorized
    end
  end

  def renew
    token = create_user_token(current_user)
    render json: { token: token }, status: :created
  end
end
