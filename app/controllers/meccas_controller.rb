# frozen_string_literal: true

class MeccasController < ApplicationController
  before_action :jwt_authenticate
  #  聖地の詳細表示
  def show
    mecca_params_id = params.permit(:id)
    mecca = Mecca.find(mecca_params_id[:id])

    if mecca.present?
      is_favorites = @user.present? && @user.favorites.exists?(mecca_id: mecca.id)
      username = mecca.user.username
      # 投稿者本人かどうかの確認を追加
      is_author = @user.present? && mecca.user_id == @user.id
      mecca_json = mecca.as_json.merge({
                                         username: username, 
                                         is_favorites: is_favorites,
                                         is_author: is_author,
                                         images: mecca.images.as_json # 画像情報を含める
                                       })

      render json: mecca_json
    else
      render json: { error: 'お探しのIDの聖地は見つかりませんでした' }, status: :not_found
    end
  end

  # 聖地を都道府県からの検索
  def prefecture
    mecca_params = params.permit(:prefecture)
    decoded_prefecture = URI.decode_www_form_component(mecca_params[:prefecture])
    meccas = Mecca.where(prefecture: decoded_prefecture)
    if meccas.any?
      meccas_json = meccas.map do |mecca|
        is_favorites = @user.present? && @user.favorites.find_by(mecca_id: mecca.id).present?
        username = mecca.user.username
        mecca.as_json.merge({
                              username: username,
                              is_favorites:,
                              images: mecca.images.as_json # 画像情報を含める
                            })
      end
      render json: meccas_json
    else
      render json: { error: 'お探しの都道府県では聖地は見つかりませんでした' }, status: :not_found
    end
  end

  # 聖地新規登録
  def create
    mecca_data = JSON.parse(params[:mecca])
    mecca = Mecca.new(mecca_data)
    mecca.user_id = @user.id

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

      begin
        mecca.save
        render json: mecca, include: :images, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

    else
      render json: mecca.errors, status: :unprocessable_entity
    end
  end

  # 聖地の編集
  def update
    mecca_params_id = params.permit(:id)
    mecca = Mecca.find(mecca_params_id[:id])
    # 投稿者本人かどうかの確認を追加
    if mecca.user_id != @user.id
      render json: { error: '投稿者本人以外は編集できません' }, status: :unauthorized
      return
    end

    if mecca.present? && mecca.valid?
      begin
        mecca.update(mecca_params)
        render json: mecca
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entityq
      end
    else
      render json: mecca.errors, status: :unprocessable_entity
    end
  end

  # 聖地の削除
  def destroy
    mecca_params_id = params.permit(:id)
    mecca = Mecca.find(mecca_params_id[:id])
    # 投稿者本人かどうかの確認を追加
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

  # ストロングパラメータ
  def mecca_params
    params.require(:mecca).permit(:mecca_name, :anime_id, :title, :episode, :scene, :place_id, :prefecture, :about)
  end

  def image_params
    params.require(:images)
  end

  # 画像の保存処理
  def image_store(mecca, images)
    images.each_value do |image_file|
      # 保存先のディレクトリを設定

      # 画像の保存処理（例：CarrierWaveを使用）
      image = mecca.images.new
      image.path = image_file
      image.save
    end
  end
end
