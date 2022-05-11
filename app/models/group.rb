class Group < ApplicationRecord
  has_many :users
  has_many :restaurant_users, through: :users
  belongs_to :vote_restaurant, optional: true
  has_many :restaurants

  def create_vote
    group = current_user.group
    votes = []
    current_user.group.users.each do |user|
      user.restaurants.each do |restaurant|
        votes << restaurant
      end
    end
    tally = {}
    votes.each do |restaurant|
      if tally[restaurant.id] == nil
        tally[restaurant.id] = 0
      end
      tally[restaurant.id] += 1
    end
    top_three = []
    i = 0
    3.times do
      top_three << tally.max_by{ |_k,v| v}[i]
      i += 1
    end
    render json: top_three
  end
  
end
