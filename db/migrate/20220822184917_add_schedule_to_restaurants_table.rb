class AddScheduleToRestaurantsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :schedule, :json
  end
end
