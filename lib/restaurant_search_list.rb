class RestaurantSearchList

  def create_list(location_id)
    @location_id = location_id
    require 'uri'
    require 'net/http'
    require 'openssl'
    # location_id = params[:chosenCity]
    # @location_id = 33364
    url = URI("https://worldwide-restaurants.p.rapidapi.com/search")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["X-RapidAPI-Host"] = 'worldwide-restaurants.p.rapidapi.com'
    request["X-RapidAPI-Key"] = ENV["RESTAURANT_API"]
    request.body = "language=en_US&limit=50&location_id=#{@location_id}&currency=USD"

    response = http.request(request)
    @restaurant_list = JSON.parse(response.read_body)["results"]["data"]
    @restaurant_list.each do |schedule|
      if schedule["hours"]
        hours = convert_schedule(schedule["hours"]["week_ranges"])
        schedule["hours"]["week_ranges"] = hours
      end
    end
    return @restaurant_list
  end

  def convert_schedule(schedule)
    i = 0
    converted_schedule = {}
    schedule.each do |day|
      if day.length == 0
        schedule[i] << "Closed"
      else
        day.each do |open|
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