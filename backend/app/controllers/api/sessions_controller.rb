class API::SessionsController < ApplicationController
  include Shared::UserTokenConcern

  def create
    params.require(:session).permit(:email, :password)
    email, password = params[:session].values_at(:email, :password)
    user = User.find_by(email: email)

    if user.try(:authenticate, password)
      token = create_user_token(user)
      render json: { token: token }, status: :created
    else
      render json: {}, status: :not_found
    end
  end

  before_action :authenticate_request, only: :test
  def test
    render json: current_user
  end
end
