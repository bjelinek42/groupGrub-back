class RestaurantsController < ApplicationController

  def index
    user = current_user
    user_restaurants = user.restaurants
    restaurants = Restaurant.all
    render json: {"restaurants" => restaurants, "user_restaurants" => user_restaurants}
  end
  
  def create
    if current_user
      duplicate_restaurant = duplicate_restaurant?(params[:location_id])
      duplicate_favorite = duplicate_favorite?(params[:location_id])
      restaurant = Restaurant.new(
        name: params[:name],
        cuisines: params[:cuisines],
        address: params[:address],
        image: params[:image],
        location_id: params[:location_id],
        schedule: params[:schedule],
        reservations: params[:reservations],
        price: params[:price],
        rating: params[:rating],
        reviews: params[:reviews],
        phone_number: params[:phone_number]
      )
      if duplicate_restaurant == false
        save_restaurant_and_favorite(restaurant)
        render json: {message: "Favorite restaurant saved"}
      elsif duplicate_favorite == false
        save_favorite(restaurant)
        render json: {message: "Favorite restaurant saved"}
      elsif duplicate_favorite == true
        render json: {message: 'Restaurant has already been added to favorites'}
      end
    else
      render json: {message: "You must be logged in to add restaurants to your favorites"}
    end
  end
  
  def search
    require 'uri'
    require 'net/http'
    require 'openssl'
    # location_id = params[:chosenCity]
    location_id = 33364
    url = URI("https://worldwide-restaurants.p.rapidapi.com/search")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["X-RapidAPI-Host"] = 'worldwide-restaurants.p.rapidapi.com'
    request["X-RapidAPI-Key"] = ENV["RESTAURANT_API"]
    request.body = "language=en_US&limit=50&location_id=#{location_id}&currency=USD"

    response = http.request(request)
    restaurant_list = JSON.parse(response.read_body)["results"]["data"]
    restaurant_list.each do |schedule|
      if schedule["hours"]
        p schedule["hours"]["week_ranges"]
        hours = convert_schedule(schedule["hours"]["week_ranges"])
        schedule["hours"]["week_ranges"] = hours
      end
    end
    # schedule = JSON.parse(response.read_body)["results"]["data"][0]["hours"]["week_ranges"]

    # converted_schedule = convert_schedule(schedule)

    # p restaurant_list[0]["hours"]["week_ranges"] = converted_schedule

    render json: restaurant_list
    
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
    request["X-RapidAPI-Key"] = ENV["RESTAURANT_API"]
    request.body = "q=#{params[:currentCity]}&language=en_US"

    response = http.request(request)
    response = JSON.parse(response.read_body)["results"]["data"]
    cities = gather_cities(response)
    render json: cities
  end

  def duplicate_restaurant?(location_id)
    duplicate = false
    all_restaurants = Restaurant.all
    while true
      all_restaurants.each do |eatery|
        if eatery.location_id == location_id
          duplicate = true
          break
        end
      end
      break
    end
    return duplicate
  end

  def duplicate_favorite?(location_id)
    duplicate = false
    all_user_favorites = RestaurantUser.where(user_id: current_user.id)
    p all_user_favorites
    restaurant = Restaurant.find_by(location_id: location_id)
    p restaurant
    if restaurant == nil
      duplicate = false
    else
      all_user_favorites.each do |favorite|
        if favorite.restaurant_id == restaurant.id
          duplicate = true
          break
        end
      end
    end
    return duplicate
  end

  def save_restaurant_and_favorite(restaurant)
    restaurant.save!
    ru = RestaurantUser.new(user_id: current_user.id, restaurant_id: restaurant.id)
    ru.save!
  end

  def save_favorite(restaurant)
    restaurant = Restaurant.find_by(location_id: params[:location_id])
    ru = RestaurantUser.new(user_id: current_user.id, restaurant_id: restaurant.id)
    ru.save!
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

  def convert_schedule(schedule)
    i = 0
    converted_schedule = {}
    schedule.each do |day|
      if day.length == 0
        schedule[i] << "Closed"
      else
        day.each do |open|
          p open
          open_hours = convert_hours(open["open_time"])
          open_minutes = convert_minutes(open["open_time"])
          close_hours = convert_hours(open["close_time"])
          close_minutes = convert_minutes(open["close_time"])
          open["open_time"] = "#{open_hours["hours"]}:#{open_minutes} #{open_hours["meridiam"]}"
          open["close_time"] = "#{close_hours["hours"]}:#{close_minutes} #{close_hours["meridiam"]}"
        end
      end
      i += 1
    end
    return schedule
  end
  
  def convert_hours(time)
    p time
    hours = time / 60
    if hours / 12.0 > 1 && hours / 12.0 !=2
      hours = (hours - 12)
      meridiam = "pm"
    elsif hours == 12
      meridiam = "pm"
    else
      if hours == 12 || hours == 0
        hours = 12
      end
      meridiam = "am"
    end
    hours = hours.to_s
    return { "hours" => hours, "meridiam" => meridiam}
  end
  
  def convert_minutes(time)
    minutes = time % 60
    if minutes == 0
      minutes = "00"
    end
    return minutes.to_s
  end
end