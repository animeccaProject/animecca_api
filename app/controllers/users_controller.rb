class UsersController < ApplicationController
  require 'jwt'

  def create
    user = User.new(user_params)
    if user.save
      render json: { user: user }, status: :created
    else
      render json: { user: user }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(username: user_params[:username])
    puts user[:username]
    if user && user.authenticate(user_params[:password])
      render json: {user: user, token: jwt_cereate_token(user) }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end


  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  def jwt_cereate_token(payload)
    payload = {username: payload[:username]}
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
