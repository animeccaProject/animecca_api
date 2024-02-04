# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :jwt_authenticate
  before_action :is_login?, only: %i[create destroy]

  def index
    fovorites = @user.favorites
    meccas = fovorites.map(&:mecca)
    if meccas.empty?
      render json: { error: 'お気に入りが見つかりません' }, status: :not_found
      return
    end

    meccas_json = meccas.map do |mecca|
      username = mecca.user.username
      mecca.as_json.merge({
                            username: username,
                            images: mecca.images.as_json # 画像情報を含める
                          })
    end
    render json: meccas_json

  end

  def create
    favorite = @user.favorites.new(mecca_id: params[:mecca_id])

    if favorite.valid?
      begin
        favorite.save
        render json: favorite
      rescue ActiveRecord::RecordNotUnique
        render json: { error: 'お気に入りが既に存在します' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'お気に入りが既に存在するか、IDが不正です' }, status: :unprocessable_entity
    end
  end

  def destroy
    favorite = @user.favorites.find_by(mecca_id: params[:mecca_id])

    if favorite.nil?
      render json: { error: 'お気に入りが見つかりません' }, status: :not_found
      return
    end

    begin
      favorite.destroy!
      render json: { message: 'お気に入りを解除しました' }
    rescue ActiveRecord::RecordNotDestroyed
      render json: favorite.errors, status: :unprocessable_entity
    end
  end

  private
  
  def is_login?
    if @user.nil?
      render json: { error: 'ログインしてください' }, status: :unauthorized
      return
    end
  end
end
