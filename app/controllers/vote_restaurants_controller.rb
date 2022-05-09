class VoteRestaurantsController < ApplicationController
  def create
    vr = Vote_restaurant.new
    render json: {message: "hey"}
  end
end
