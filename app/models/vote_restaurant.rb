class VoteRestaurant < ApplicationRecord
  has_many :users
  has_many :groups
  has_many :restaurants
end
