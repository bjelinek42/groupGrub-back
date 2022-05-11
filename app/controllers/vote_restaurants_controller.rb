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
    vr = VoteRestaurant.find(params[:id]) #locate vote entered
    all_votes = VoteRestaurant.where(group_id: current_user.group_id, active: true) #all_votes = all active votes for group
    check_previous = VoteRestaurant.where(user_id: current_user.id, active: true) # cp = all current user's possible votes
    already_voted = false
    if all_votes == [] #if no active votes, then already voted as it flips them, and skip the lower tally, tell already voted
      already_voted = true
    else # if there are votes, check to see if the user has already voted, and if yes, skip lower tally
      check_previous.each do |vote|
        if vote.vote == true 
          already_voted = true
        end
      end
    end
    if already_voted == false # if have not voted, put in vote and save
      vr.vote = true
      vr.save
      check_all_votes = VoteRestaurant.where(vote: true, group_id: current_user.group_id, active: true) #find amount of casted votes for restaurant
      if check_all_votes.length == current_user.group.users.length #if there are as many votes as users, switch them all to inactive as vote is concluded

        group = current_user.group #current users group
        votes = VoteRestaurant.where(group_id: group.id) #gather votes for current group
        total_votes = 0
        votes_for = {}
        tally = {}
        votes.each do |vote| #go through votes and tally the for votes
          if tally[vote.restaurant_id] == nil
            tally[vote.restaurant_id] = 0
          end
          if vote.vote == true && vote.active == true
            tally[vote.restaurant_id] += 1
            total_votes += 1
          end
        end
        all_votes_in = false
        if total_votes == group.users.length
          all_votes_in = true
        end
        all_votes.each do |vote|
          vote.active = false
          vote.save
        end
        winning_restaurant = tally.sort_by { |_k, v| -v }.first(1).map(&:first)
        winning_restaurant = Restaurant.find(winning_restaurant)
        if all_votes_in == true
          g = Group.find(current_user.group.id)
          g.restaurant_id = winning_restaurant[0].id
          g.save!
        end
      end
      render json: {message: "Your vote has been recorded"}
    else
      render json: {message: "You have already voted. No ballot stuffing!"}
    end
  end

  def index
    user = current_user
    @restaurants = []
    vote_hash = {}
    @vote_restaurants = VoteRestaurant.where(user_id: current_user.id, active: true)
    render template: "vote_restaurants/index"
  end
end
