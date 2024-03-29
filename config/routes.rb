Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/users/group" => "groups#show"
  get "/groups" => "groups#index"

  get "/users/:id" => "users#show"
  post "/users" => "users#create"

  post "/sessions" => "sessions#create"

  post "/restaurants" => "restaurants#create"
  get "/restaurants" => "restaurants#index"
  get "/restaurants/search" => "restaurants#search"
  post "/restaurants/search" => "restaurants#find_city"

  get "/vote_restaurants" => "vote_restaurants#index"
  post "/vote_restaurants" => "vote_restaurants#create"
  patch "/vote_restaurants/:id" => "vote_restaurants#update"

  delete "/restaurant_users" => "restaurant_users#destroy"

  get "/*path" => proc { [200, {}, [ActionView::Base.new.render(file: 'public/index.html')]] }
end
