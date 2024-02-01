# frozen_string_literal: true

class MeccasController < ApplicationController
  before_action :jwt_authenticate, only: %i[create update]

  # 聖地の一覧表示
  def create
    mecca = Mecca.new(mecca_params)
    mecca.user_id = @user.id
    # ここにイメージの保存処理を追加
    # 保存先はpublic/images/[mecca_id]/[image_id].jpg or png

    # 画像データの取得
    image_data = params[:mecca][:image]

    if image_data
      # 保存先ディレクトリの確認と作成
      FileUtils.mkdir_p(Rails.root.join('public', 'images', mecca.id.to_s))

      # 画像の保存パスの設定
      file_path = Rails.root.join('public', 'images', mecca.id.to_s,
                                  "#{SecureRandom.uuid}.#{image_data.content_type.split('/').last}")

      # 画像の保存
      File.open(file_path, 'wb') do |file|
        file.write(image_data.read)
      end

      # オプション: 画像パスをデータベースに保存
      # mecca.image_path = file_path.relative_path_from(Rails.root.join('public'))
    end
    # -----------------
    if mecca.valid?
      mecca.save
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

  def destroy
    mecca_params_id = params.permit(:id)
    mecca = Mecca.find(mecca_params_id[:id])
    # 投稿者本人かどうかの確認を追加
    if mecca.user_id != @user.id
      render json: { error: '投稿者本人以外は削除できません' }, status: :unauthorized
      return
    end

    if mecca.destroy
      render json: mecca
    else
      render json: mecca.errors, status: :unprocessable_entity
    end
  end

  private

  def mecca_params
    params.require(:mecca).permit(:mecca_name, :anime_id, :title, :episode, :scene, :place_id, :prefecture, :about,
                                  :image)
  end
end
