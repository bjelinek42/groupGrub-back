class VoteRestaurantsController < ApplicationController
  def create
    if VoteRestaurant.where(group_id: current_user.group_id, active: true) != []
      render json: {message: "only one vote allowed at a time. Please finish current vote"}
    else
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
  end

  def update
    vr = VoteRestaurant.find(params[:id])
    check_previous = VoteRestaurant.where(user_id: current_user.id)
    p check_previous
    already_voted = false
    check_previous.each do |vote|
      if vote.vote == true
        already_voted = true
      end
    end
    if already_voted == false
      vr.vote = true
      vr.save
      render json: {message: "vote placed for #{vr}"}
    else
      render json: {message: "You have can only vote once"}
    end
  end

  def index
    user = current_user
    @restaurants = []
    vote_hash = {}
    @vote_restaurants = VoteRestaurant.where(user_id: current_user.id)
    # @vote_restaurants.each do |option|
    #   r = Restaurant.find(option.restaurant_id)
    #   @restaurants << r
    # end
    render template: "vote_restaurants/index"
  end
end
