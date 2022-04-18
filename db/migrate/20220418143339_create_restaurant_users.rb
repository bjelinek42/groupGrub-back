class CreateRestaurantUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurant_users do |t|
      t.integer :restaurant_id
      t.integer :user_id

      t.timestamps
    end
  end
end
