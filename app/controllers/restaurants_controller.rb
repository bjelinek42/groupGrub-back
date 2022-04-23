class RestaurantsController < ApplicationController
  
  
  def index
    user = current_user
    restaurants = user.restaurants
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
      ru = RestaurantUser.new(user_id: current_user.id, restaurant_id: restaurant.id)
      ru.save
      render json: restaurant
    else
      render json: {message: "You must be logged in to create a new restaurant"}
    end
  end    
end
