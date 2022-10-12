class Restaurant < ApplicationRecord
  has_many :restaurant_users
  has_many :users, through: :restaurant_users
  belongs_to :vote_restaurant, optional: true
  has_many :groups_restaurants
  has_many :groups, through: :groups_restaurants

end
