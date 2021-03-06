class Restaurant < ApplicationRecord
  has_many :restaurant_users
  has_many :users, through: :restaurant_users
  belongs_to :vote_restaurant, optional: true
end
