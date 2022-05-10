class RestaurantUsersController < ApplicationController
  def destroy
    ru = RestaurantUser.find_by(user_id: params[:user_id], restaurant_id: params[:restaurant_id])
    ru.destroy
    render json: {message: "Restaurant deleted successfully"}
  end
end
