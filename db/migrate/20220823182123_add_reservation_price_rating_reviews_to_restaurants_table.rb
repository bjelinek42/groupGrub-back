class AddReservationPriceRatingReviewsToRestaurantsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :reservations, :string
    add_column :restaurants, :price, :string
    add_column :restaurants, :rating, :string
    add_column :restaurants, :reviews, :string
  end
end
