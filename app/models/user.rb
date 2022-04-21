class User < ApplicationRecord
  has_secure_password
  has_many :restaurant_users
  has_many :restaurants, through: :restaurant_users
  validates :email, presence: true, uniqueness: true
end
