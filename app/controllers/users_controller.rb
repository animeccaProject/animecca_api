# frozen_string_literal: true

class UsersController < ApplicationController
  # userの作成
  def create
    user = User.new(user_params)
    if user.valid?
      begin
        user.save
        render json: { user: }, status: :created
      rescue ActiveRecord::RecordNotUnique
        render json: { error: 'ユーザーネームが既に存在します' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'ユーザーネームが既に存在するか、不正な文字が含まれています' }, status: :unprocessable_entity
    end
  end

  # userのログイン
  def login
    user = User.find_by(username: user_params[:username])
    # userが存在するかつパスワードが正しい場合
    if user&.authenticate(user_params[:password])
      render json: { user: { username: user[:username], id: user[:id], token: jwt_cereate_token(user) } }, status: :ok
    else
      render json: { error: 'パスワード、またはユーザーネームが違います' }, status: :unauthorized
    end
  end

  private

  # userの入力制限用のパラメーター設定
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  # jwtのトークン作成
  def jwt_cereate_token(payload)
    begin
      payload = { user_id: payload[:id] }
      JWT.encode(payload, Rails.application.credentials.secret_key_base)
    rescue StandardError
      nil
    end
  end
end
