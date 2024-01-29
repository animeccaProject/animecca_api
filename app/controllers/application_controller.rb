class ApplicationController < ActionController::API
  require 'jwt'
  
  # jwtの認証
  
  def jwt_authenticate
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ')[1]
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
      username = decoded_token[0]['username']
      @user = User.find_by(username: username) # 各コントローラーでは@userでログインユーザーが取得できる
    rescue
      @user = nil
    end
  end
end
