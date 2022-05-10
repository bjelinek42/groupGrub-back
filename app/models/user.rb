class User < ApplicationRecord
  has_secure_password
  has_many :restaurant_users
  has_many :restaurants, through: :restaurant_users
  belongs_to :group
  validates :email, presence: true, uniqueness: true
  belongs_to :vote_restaurant, optional: true
end
