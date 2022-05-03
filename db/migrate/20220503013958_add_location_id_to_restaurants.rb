class AddLocationIdToRestaurants < ActiveRecord::Migration[7.0]
  def change
    add_column  :restaurants, :location_id, :string
  end
end
