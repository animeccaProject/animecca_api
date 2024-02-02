class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :mecca
  validates :mecca_id, uniqueness: { scope: :user_id}
end
