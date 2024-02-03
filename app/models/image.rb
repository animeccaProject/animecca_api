class Image < ApplicationRecord
  mount_uploader :path, ImageUploader
  belongs_to :mecca
end
