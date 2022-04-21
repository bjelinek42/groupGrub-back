class RestaurantsController < ApplicationController
  def index
    restaurants = Restaurant.all
    render json: restaurants
  end
  
  def create
    restaurant = Restaurant.new(
      name: params[:name],
      cuisines: params[:cuisines],
      address: params[:address],
      image: params[:image]
    )
    restaurant.save
    render json: restaurant
  end    
end
