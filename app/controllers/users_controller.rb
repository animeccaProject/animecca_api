class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      render json: { status: 201, user: user }
    else
      render json: { status: 422, user: user }
    end
  end

  def login
    user = User.find_by(username: user_params[:username])
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
    payload = {username: payload.id}
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
