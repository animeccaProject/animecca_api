# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :jwt_authenticate, only: %i[create destroy]

  def create
    @favorite = @user.favorites.create(mecca_id: params[:mecca_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @mecca = Mecca.find(params[:mecca_id])
    @favorite = @user.favorites.find_by(mecca_id: @mecca.id)
    @favorite&.destroy
    redirect_back(fallback_location: root_path)
  end
end
