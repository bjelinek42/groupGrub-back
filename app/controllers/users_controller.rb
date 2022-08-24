class UsersController < ApplicationController
  
  def create
    user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      group_id: params[:group_id]
    )
    if user.save
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def show
    if current_user
      @user = current_user
      restaurants = @user.restaurants
      group = @user.group
      # render template: "users/show"
      render json: {"user" => @user, "restaurants" => restaurants, "group" => group}
    else
      render json: {message: "You must be logged in view your profile"}, status: :unauthorized
    end
  end

end
