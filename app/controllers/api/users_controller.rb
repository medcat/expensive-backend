class API::UsersController < ApplicationController
  include Shared::UserTokenConcern

  def create
    user = User.new(user_parameters)

    if user.save
      token = create_user_token(user)
      render json: { token: token }, status: :created
    else
      details = user.errors.details
      render json: { errors: details }, status: :unprocessable_entity
    end
  end

private

  def user_parameters
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
