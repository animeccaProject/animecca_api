# frozen_string_literal: true

class ApplicationController < ActionController::API
  require 'jwt'

  # jwtの認証

  def jwt_authenticate
    auth_header = request.headers['Authorization']

    if auth_header.nil?
      @user = nil
      return
    end

    token = auth_header.split(' ')[1]
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
      user_id = decoded_token[0]['user_id']
      puts user_id
      # 各コントローラーでは@userでログインユーザーが取得できる
      # @userがうまくいかない場合は下記のメモを参照
      @user = User.find(user_id)
    rescue StandardError
      @user = nil
    end
  end
end

# Dockerを使用してのJWT認証の実装は以下に注意
# credentials.yml.encのsecret_key_baseがnilになる場合はconfig/master.keyがあるか確認
# ない場合は以下の手順で対応
# credentials.yml.encを削除
# "sudo EDITOR=vim rails credentials:edit"を実行してmaster.keyを作成,保存
# マスターキーのパミッションを644に変更
# dockerは再ビルドしてください
