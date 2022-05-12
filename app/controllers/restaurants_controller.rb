class RestaurantsController < ApplicationController

  def index
    user = current_user
    user_restaurants = user.restaurants
    restaurants = Restaurant.all
    render json: {"restaurants" => restaurants, "user_restaurants" => user_restaurants}
  end
  
  def create
    if current_user
      duplicate = duplicate_restaurant?()
      # duplicate = false
      # all_restaurants = Restaurant.all
      # while true
      #   all_restaurants.each do |eatery|
      #     if eatery.location_id == params[:location_id]
      #       duplicate = true
      #       break
      #     end
      #   end
      #   break
      # end
      restaurant = Restaurant.new(
        name: params[:name],
        cuisines: params[:cuisines],
        address: params[:address],
        image: params[:image],
        location_id: params[:location_id],
      )
      if duplicate == false
        save_restaurant_and_favorite(restaurant)
        # restaurant.save
        # ru = RestaurantUser.new(user_id: current_user.id, restaurant_id: restaurant.id)
        # ru.save
        # render json: restaurant
      else
        save_favorite(restaurant)
        # restaurant = Restaurant.find_by(location_id: params[:location_id])
        # ru = RestaurantUser.new(user_id: current_user.id, restaurant_id: restaurant.id)
        # ru.save
        # render json: ru
      end
    else
      render json: {message: "You must be logged in to create a new restaurant"}
    end
  end
  
  def search
    require 'uri'
    require 'net/http'
    require 'openssl'
    location_id = params[:chosenCity]
    url = URI("https://worldwide-restaurants.p.rapidapi.com/search")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["X-RapidAPI-Host"] = 'worldwide-restaurants.p.rapidapi.com'
    request["X-RapidAPI-Key"] = Rails.application.credentials.ww_restaurants_api_key
    request.body = "language=en_US&limit=1000&location_id=#{location_id}&currency=USD"

    response = http.request(request)

    render json: JSON.parse(response.read_body)["results"]["data"]
  end

  def find_city
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://worldwide-restaurants.p.rapidapi.com/typeahead")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["X-RapidAPI-Host"] = 'worldwide-restaurants.p.rapidapi.com'
    request["X-RapidAPI-Key"] = Rails.application.credentials.ww_restaurants_api_key
    request.body = "q=#{params[:currentCity]}&language=en_US"

    response = http.request(request)
    response = JSON.parse(response.read_body)["results"]["data"]
    cities = gather_cities(response)
    # cities = []
    # response.each do |city|
    #   location = {}
    #   name = city["result_object"]["location_string"]
    #   location_id = city["result_object"]["location_id"]
    #   location["city"] = name
    #   location["location_id"] = location_id
    #   cities << location
    # end
    render json: cities
  end

  def duplicate_restaurant?()
    duplicate = false
    all_restaurants = Restaurant.all
    while true
      all_restaurants.each do |eatery|
        if eatery.location_id == params[:location_id]
          duplicate = true
          break
        end
      end
      break
    end
    return duplicate
  end

  def save_restaurant_and_favorite(restaurant)
    restaurant.save!
    ru = RestaurantUser.new(user_id: current_user.id, restaurant_id: restaurant.id)
    ru.save!
    render json: restaurant
  end

  def save_favorite(restaurant)
    restaurant = Restaurant.find_by(location_id: params[:location_id])
    ru = RestaurantUser.new(user_id: current_user.id, restaurant_id: restaurant.id)
    ru.save!
    render json: ru
  end

  def gather_cities(response)
    cities = []
    response.each do |city|
      location = {}
      name = city["result_object"]["location_string"]
      location_id = city["result_object"]["location_id"]
      location["city"] = name
      location["location_id"] = location_id
      cities << location
    end
    return cities
  end
end
