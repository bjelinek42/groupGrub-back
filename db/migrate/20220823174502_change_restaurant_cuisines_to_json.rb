class ChangeRestaurantCuisinesToJson < ActiveRecord::Migration[7.0]
  def change 
    remove_column :restaurants, :cuisines
  end

  def change
    add_column :restaurants, :cuisines, :json
  end
end
