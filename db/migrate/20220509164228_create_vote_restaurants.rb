class CreateVoteRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :vote_restaurants do |t|
      t.integer :group_id
      t.integer :restaurant_id
      t.boolean :active
      t.boolean :vote
      t.integer :user_id

      t.timestamps
    end
  end
end
