class MeccasController < ApplicationController
before_action :jwt_authenticate, only: [:create, :update]

  def create
    mecca = Mecca.create(mecca_params)
    if mecca.valid?
      render json: mecca
    else
      render json: mecca.errors, status: :unprocessable_entity
    end
  end

  def show
    mecca_params_id = params.permit(:id)
    mecca = Mecca.find(mecca_params_id[:id])
    if mecca
      render json: mecca
    else
      render json: { error: 'お探しのIDの聖地は見つかりませんでした' }, status: :not_found
    end
  end

  def prefecture
    mecca_params = params.permit(:prefecture)
    meccas = Mecca.where(prefecture: mecca_params[:prefecture])
    if meccas
      render json: meccas
    else
      render json: { error: 'お探しの都道府県では聖地は見つかりませんでした' }, status: :not_found
    end
  end

  def update
    mecca_params_id = params.permit(:id)
    mecca = Mecca.find(mecca_params_id[:id])
    if mecca.update(mecca_params)
      render json: mecca
    else
      render json: mecca.errors, status: :unprocessable_entity
    end
  end
  private

  def mecca_params
    params.require(:mecca).permit(:mecca_name, :anime_id, :title, :episode, :scene, :place_id, :prefecture, :about)
  end
end
