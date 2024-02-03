# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :jwt_authenticate, only: %i[index create destroy]

  def index
    fovorites = @user.favorites
    meccas = fovorites.map { |favorite| favorite.mecca }
    if fovorites.nil?
      render json: { error: 'お気に入りが見つかりません' }, status: :not_found
      return
    end

    render json: meccas
  end

  def create
    favorite = @user.favorites.new(mecca_id: params[:mecca_id])
    if favorite.save
      render json: favorite
    else
      render json: favorite.errors, status: :unprocessable_entity
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

end
