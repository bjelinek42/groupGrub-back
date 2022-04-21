class RestaurantsController < ApplicationController
  def index
    restaurants = Restaurant.all
    render json: restaurants
  end
  
  def create
    if current_user
      restaurant = Restaurant.new(
        name: params[:name],
        cuisines: params[:cuisines],
        address: params[:address],
        image: params[:image]
      )
      restaurant.save
      render json: restaurant
    else
      render json: {message: "You must be logged in to create a new restaurant"}
    end
  end    
end
