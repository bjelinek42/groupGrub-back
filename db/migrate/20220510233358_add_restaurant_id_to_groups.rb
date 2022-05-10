class AddRestaurantIdToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :restaurant_id, :integer
  end
end
