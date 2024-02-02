class Image < ApplicationRecord
  mount_uploader :image_path, ImageUploader
  belongs_to :mecca
end
