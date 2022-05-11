class GroupsController < ApplicationController

  def show
    @group = current_user.group
    votes = VoteRestaurant.where(group_id: @group.id)
    total_votes = 0
    votes_for = {}
    tally = {}
    votes.each do |vote|
      if tally[vote.restaurant_id] == nil
        tally[vote.restaurant_id] = 0
      end
      if vote.vote == true && vote.active == true
        tally[vote.restaurant_id] += 1
        total_votes += 1
      end
    end
    @all_votes = false
    if total_votes == @group.users.length
      @all_votes = true
    end
    @winning_restaurant = tally.sort_by { |_k, v| -v }.first(1).map(&:first)
    @winning_restaurant = Restaurant.find(@winning_restaurant)
    if @all_votes == true
      g = Group.find(current_user.group.id)
      g.restaurant_id = @winning_restaurant[0].id
      g.save
    end
    render template: "groups/show"
  end

end
