class UsersController < ApplicationController

  # userの作成
  def create
    user = User.new(user_params)
    if user.save
      render json: { user: user }, status: :created
    else
      render json: { user: user }, status: :unprocessable_entity
    end
  end

  # userのログイン
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

  # userの入力制限用のパラメーター設定
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  # jwtのトークン作成
  def jwt_cereate_token(payload)
    payload = {user_id: payload[:id]}
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
