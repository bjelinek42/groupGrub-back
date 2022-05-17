class GroupsController < ApplicationController

  def show
    @group = current_user.group
    @all_votes = false
    total_votes = VoteRestaurant.where(group_id: current_user.group.id, active: true)
    if total_votes.length == 0
      @all_votes = true
    end
    if Restaurant.find_by(id: @group.restaurant_id)
      @winning_restaurant = Restaurant.find_by(id: @group.restaurant_id)
    else
      @winning_restaurant = "None"
    end
    p @winning_restaurant
    render template: "groups/show"
  end

  def index
    g = Group.all
    render json: g
  end
end
