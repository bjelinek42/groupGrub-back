class VoteRestaurantsController < ApplicationController
  def create
    current_vote = VoteRestaurant.where(group_id: current_user.group_id, active: true)
    if current_vote.length != 0
      render json: {message: "Only one vote allowed at a time. Please finish current vote"}
    else
      votes = create_tally()
      top_three_restaurants = top_three_tally(votes)
      ballot = create_ballot(top_three_restaurants)
      render json: ballot
    end
  end

  def update
    vr = VoteRestaurant.find_by(id: params[:id])
    already_voted?()
    all_votes = VoteRestaurant.where(group_id: current_user.group_id, active: true)
    if already_voted? == false
      vr.vote = true
      vr.save
      check_all_votes = VoteRestaurant.where(vote: true, group_id: current_user.group_id, active: true)
      if check_all_votes.length == current_user.group.users.length
        group = current_user.group
        votes = VoteRestaurant.where(group_id: group.id)
        total_votes = total_votes(votes)
        winning_restaurant = final_tally(votes)
        all_votes_in = all_votes_in?(votes)
        if all_votes_in == true
          inactivate_vote()
          save_winning_restaurant_to_group(winning_restaurant)
          render json: {message: "Your vote has been recorded, and all votes are in.", all_votes_in: true}
        end
      else
        render json: {message: "Your vote has been recorded"}
      end
    else
      render json: {message: "You have already voted. No ballot stuffing!"}
    end
  end

  def index
    @user = current_user
    @restaurants = []
    vote_hash = {}
    @vote_restaurants = VoteRestaurant.where(user_id: current_user.id, active: true)
    render template: "vote_restaurants/index"
  end

  def create_tally
    group = current_user.group
    votes = []
    current_user.group.users.each do |user|
      user.restaurants.each do |restaurant|
        votes << restaurant
      end
    end
    return votes
  end

  def top_three_tally(votes)
    tally = {}
    votes.each do |restaurant|
      if tally[restaurant.id] == nil
        tally[restaurant.id] = 0
      end
      tally[restaurant.id] += 1
    end
    top_three = tally.sort_by { |_k, v| -v }.first(3).map(&:first)
    return top_three
  end

  def create_ballot(top_three_restaurants)
    ballot = []
    j = 0
    current_user.group.users.length.times do
      i = 0
      user_id = current_user.group.users[j].id
      3.times do
        vr = VoteRestaurant.new(
          group_id: current_user.group_id,
          restaurant_id: top_three_restaurants[i],
          active: true,
          vote: false,
          user_id: user_id
        )
        vr.save
        i += 1
        ballot << vr
      end
      j += 1
    end
    return ballot
  end

  def already_voted?()
    already_voted = false
    all_group_votes = VoteRestaurant.where(group_id: current_user.group_id, active: true)
    user_possible_votes = VoteRestaurant.where(user_id: current_user.id, active: true)
    if all_group_votes.length == 0 #checks if any are active. If not, user has already voted
      already_voted = true
    else
      user_possible_votes.each do |vote|
        if vote.vote == true #if one true, then user has voted
          already_voted = true
        end
      end
    end
    return already_voted
  end

  def final_tally(votes)
    tally = {}
    votes.each do |vote|
      if tally[vote.restaurant_id] == nil
        tally[vote.restaurant_id] = 0
      end
      if vote.vote == true && vote.active == true
        tally[vote.restaurant_id] += 1
      end
    end
    winning_restaurant = tally.sort_by { |_k, v| -v }.first(1).map(&:first)
    winning_restaurant = Restaurant.find_by(id: winning_restaurant)
    return winning_restaurant
  end

  def total_votes(votes)
    total_votes = 0
    votes.each do |vote|
      if vote.vote == true && vote.active == true
        total_votes += 1
      end
    end
    return total_votes
  end

  def all_votes_in?(votes)
    group = current_user.group
    total_votes = 0
    votes.each do |vote|
      if vote.vote == true && vote.active == true
        total_votes += 1
      end
    end
    all_votes_in = false
    if total_votes == group.users.length
      all_votes_in = true
    end
    return all_votes_in
  end

  def inactivate_vote
    all_votes = VoteRestaurant.where(group_id: current_user.group_id, active: true)
    all_votes.each do |vote|
      vote.active = false
      vote.save
    end
  end

  def save_winning_restaurant_to_group(winning_restaurant)
    g = Group.find(current_user.group.id)
    g.restaurant_id = winning_restaurant.id
    g.save
  end

end
