class CreateGroupsRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :groups_restaurants do |t|
      t.integer :restaurant_id
      t.integer :group_id

      t.timestamps
    end
  end
end
