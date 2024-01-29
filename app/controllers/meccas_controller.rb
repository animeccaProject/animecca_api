class MeccasController < ApplicationController
before_action :jwt_authenticate, only: [:create, :update]

  # 聖地の一覧表示
  def create
    mecca = Mecca.create(mecca_params)
    if mecca.valid?
      render json: mecca
    else
      render json: mecca.errors, status: :unprocessable_entity
    end
  end

  #  聖地の詳細表示
  def show
    mecca_params_id = params.permit(:id)
    mecca = Mecca.find(mecca_params_id[:id])
    if mecca
      render json: mecca
    else
      render json: { error: 'お探しのIDの聖地は見つかりませんでした' }, status: :not_found
    end
  end

  # 聖地を都道府県からの検索
  def prefecture
    mecca_params = params.permit(:prefecture)
    meccas = Mecca.where(prefecture: mecca_params[:prefecture])
    if meccas
      render json: meccas
    else
      render json: { error: 'お探しの都道府県では聖地は見つかりませんでした' }, status: :not_found
    end
  end

  # 聖地の編集
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
