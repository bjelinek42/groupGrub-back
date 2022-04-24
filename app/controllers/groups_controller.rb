class GroupsController < ApplicationController

  def show
    group = current_user.group
    votes = []
    current_user.group.users.each do |user|
      user.restaurants.each do |restaurant|
        votes << restaurant
      end
    end
    
    render json: votes
  end

end
