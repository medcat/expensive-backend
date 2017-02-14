class UsersController < ApplicationController
  def create
    user = User.new(user_parameters)
    if user.save
      user.save
      render json: { success: true }, status: :created
    else
      render json: { success: false, errors: user.errors }, status: 400
    end
  end

private

  def user_parameters
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
