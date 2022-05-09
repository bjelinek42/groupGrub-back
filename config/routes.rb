Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/users/:id" => "users#show"
  post "/users" => "users#create"

  post "/sessions" => "sessions#create"

  get "/restaurants" => "restaurants#index"
  post "/restaurants" => "restaurants#create"
  get "/restaurants/search" => "restaurants#search"
  post "/restaurants/search" => "restaurants#find_city"

  get "/groups/:id" => "groups#show"

  post "/vote_restaurant" => "vote_restaurant#create"
  
end
