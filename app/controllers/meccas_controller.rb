# frozen_string_literal: true

class MeccasController < ApplicationController
  before_action :jwt_authenticate, only: %i[create update]

  # 聖地の一覧表示
  def create
    mecca_data = JSON.parse(params[:mecca])
    mecca = Mecca.new(mecca_data['mecca'])
    mecca.user_id = @user.id
  
    if mecca.valid?

      if mecca.save
        render json: mecca
      else
        render json: mecca.errors, status: :unprocessable_entity
      end
      
      # 画像データがある場合、処理を行う
      image_data = image_params
      if image_data.present?
        begin
          image_store(mecca, image_data)
        rescue StandardError => e
          mecca.errors.add(:image, e.message)
        end
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
    params.require(:mecca).permit(:mecca_name, :anime_id, :title, :episode, :scene, :place_id, :prefecture, :about)
  end

  def image_params
    params.require(:image)
  end

  def image_store(mecca_data, image_data)
    # 保存先ディレクトリの確認と作成
    FileUtils.mkdir_p(Rails.root.join('public', 'images', mecca_data.id.to_s))

    # ファイルネームの設定
    filename = "#{Time.zone.now.to_i}_#{SecureRandom.hex(10)}_#{image_data.original_filename}"

    # 画像の保存パスの設定
    file_path = Rails.root.join('public', 'images', mecca_data.id.to_s,
                                filename)

    # 画像の保存
    File.open(file_path, 'wb') do |file|
      file.write(image_data.read)
    end

    # オプション: 画像パスをデータベースに保存
    mecca_data.image_path = file_path.relative_path_from(Rails.root.join('public'))
  end
end
