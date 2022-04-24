class GroupsController < ApplicationController

  def show
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
    render json: tally
  end

end
