class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { status: 'success', message: 'Account created successfully!', data: @user }, status: :created
    else
      render json: { status: 'error', message: 'Account creation failed', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name)
  end
end
