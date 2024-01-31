class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :meccas, through: :favorites
  validates :username, presence: true, uniqueness: true, length: {minimum:3}
  has_secure_password
  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                       length: { minimum: 6 },
                       format: {
                         with: VALID_PASSWORD_REGEX
                       },
                       allow_nil: true
end
