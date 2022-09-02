class GroupsRestaurant < ApplicationRecord
  belongs_to :restaurant
  belongs_to :group
end
