class UsersController < ApplicationController
  include Shared::UserTokenConcern

  def create
    user = User.new(user_parameters)

    if user.save
      user.save
      render json: { success: true, token: create_user_token(user) },
        status: :created
    else
      render json: { success: false, errors: user.errors.details },
        status: :bad_request
    end
  end

private

  def user_parameters
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
