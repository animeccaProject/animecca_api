class Mecca < ApplicationRecord
  validates :mecca_name, presence: true
  validates :anime_id, presence: true
  validates :title, presence: true
  validates :place_id, presence: true
  validates :prefecture, presence: true
  validates :user_id, presence: true
  validates :about, length: {maximum: 1200}
end
