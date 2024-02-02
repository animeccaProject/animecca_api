# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :jwt_authenticate, only: %i[create destroy]

  def create
    @favorite = @user.favorites.new(mecca_id: params[:mecca_id])
    if @favorite.save
      render json: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @mecca = Mecca.find(params[:mecca_id])
    @favorite = @user.favorites.find_by(mecca_id: @mecca.id)

    if @favorite.destroy
      render json: @favorite, status: :ok
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end
end
