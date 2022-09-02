class Group < ApplicationRecord
  has_many :users
  has_many :restaurant_users, through: :users
  belongs_to :vote_restaurant, optional: true
  has_many :restaurants
  has_many :restaurants, through: :groups_restaurants
  
end
