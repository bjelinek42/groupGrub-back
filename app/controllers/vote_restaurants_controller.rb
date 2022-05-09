class VoteRestaurantsController < ApplicationController
  def create
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
    top_three = tally.sort_by { |_k, v| -v }.first(3).map(&:first)
    # i = 0
    # 3.times do
    #   top_three << tally.max_by{ |_k,v| v}[i]
    #   i += 1
    # end
    sanity = []
    j = 0
    group.users.length.times do
      i = 0
      user_id = group.users[j].id
      3.times do
        vr = VoteRestaurant.new(
          group_id: current_user.group_id,
          restaurant_id: top_three[i],
          active: true,
          vote: false,
          user_id: user_id
        )
        vr.save
        i += 1
        sanity << vr
      end
      j += 1
    end
    render json: sanity
  end

  def update
    vr = VoteRestaurant.find(params[:id])
    vr.vote = true
    vr.save
    render json: vr
  end

  def index
    user = current_user
    restaurants = []
    vote_hash = {}
    vr = VoteRestaurant.where(user_id: 1) #current_user.id
    vr.each do |option|
      r = Restaurant.find(option.restaurant_id)
      vote_hash = {}
      vote_hash[option.id] = r
      restaurants << vote_hash
    end
    render json: restaurants
  end
end
