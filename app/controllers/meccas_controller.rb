# frozen_string_literal: true

class MeccasController < ApplicationController
  before_action :jwt_authenticate, only: %i[create update destroy]

  #  聖地の詳細表示
  def show
    mecca_params_id = params.permit(:id)
    mecca = Mecca.find(mecca_params_id[:id])

    if mecca.present?
      render json: mecca, include: :images
    else
      render json: { error: 'お探しのIDの聖地は見つかりませんでした' }, status: :not_found
    end
  end

  # 聖地を都道府県からの検索
  def prefecture
    mecca_params = params.permit(:prefecture)
    meccas = Mecca.where(prefecture: mecca_params[:prefecture])
    if meccas
      render json: meccas, include: :images
    else
      render json: { error: 'お探しの都道府県では聖地は見つかりませんでした' }, status: :not_found
    end
  end

  # 聖地新規登録
  def create
    mecca_data = JSON.parse(params[:mecca])
    mecca = Mecca.new(mecca_data['mecca'])
    mecca.user_id = @user.id
    puts mecca.user_id
  
    if mecca.valid?

      
      # 画像データがある場合、処理を行う
      images = image_params
      if images.present?
        begin
          image_store(mecca, images)
        rescue StandardError => e
          mecca.errors.add(:image, e.message)
        end
      end
      
      if mecca.save
        render json: mecca, include: :images, status: :created
      else
        render json: mecca.errors, status: :unprocessable_entity
      end
      
    else
      render json: mecca.errors, status: :unprocessable_entity
    end

  end
  

  # 聖地の編集
  def update
    mecca = Mecca.find_by(id: params[:id])
    # 投稿者本人かどうかの確認を追加
    if mecca.user_id != @user.id
      render json: { error: '投稿者本人以外は編集できません' }, status: :unauthorized
      return
    end

    if mecca.update(mecca_params)
      render json: mecca
    else
      render json: mecca.errors, status: :unprocessable_entity
    end
  end

  # 聖地の削除
  def destroy
    mecca = Mecca.find_by(id: params[:id])
    if mecca.user_id != @user.id
      render json: { error: '投稿者本人以外は削除できません' }, status: :unauthorized
      return
    end

    if mecca.destroy
      render json: { message: '聖地を削除しました' }
    else
      render json: mecca.errors, status: :unprocessable_entity
    end
  end

  private

  def mecca_params
    params.require(:mecca).permit(:mecca_name, :anime_id, :title, :episode, :scene, :place_id, :prefecture, :about)
  end

  def image_params
    params.require(:images)
  end

  def image_store(mecca, images)
    images.each do |image_file|
      # 保存先のディレクトリを設定
  
      # 画像の保存処理（例：CarrierWaveを使用）
      image = mecca.images.new
      image.path = image_file
      image.save
    end
  end
end
