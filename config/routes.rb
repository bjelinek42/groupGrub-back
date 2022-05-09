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

  get "/vote_restaurants" => "vote_restaurants#index"
  post "/vote_restaurants" => "vote_restaurants#create"
  patch "/vote_restaurants/:id" => "vote_restaurants#update"

end
