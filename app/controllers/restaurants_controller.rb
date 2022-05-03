class RestaurantsController < ApplicationController

  def index
    user = current_user
    user_restaurants = user.restaurants
    restaurants = Restaurant.all
    render json: {"restaurants" => restaurants, "user_restaurants" => user_restaurants}
  end
  
  def create
    if current_user
      restaurant = Restaurant.new(
        name: params[:name],
        cuisines: params[:cuisines],
        address: params[:address],
        image: params[:image],
        location_id: params[:location_id],
      )
      restaurant.save
      ru = RestaurantUser.new(user_id: current_user.id, restaurant_id: restaurant.id)
      ru.save
      render json: restaurant
    else
      render json: {message: "You must be logged in to create a new restaurant"}
    end
  end
  
  def search
    require 'uri'
    require 'net/http'
    require 'openssl'
    
    url = URI("https://worldwide-restaurants.p.rapidapi.com/search")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["X-RapidAPI-Host"] = 'worldwide-restaurants.p.rapidapi.com'
    request["X-RapidAPI-Key"] = Rails.application.credentials.ww_restaurants_api_key
    request.body = "language=en_US&limit=1&location_id=33364&currency=USD"

    response = http.request(request)

    render json: JSON.parse(response.read_body)["results"]["data"]
  end
end
