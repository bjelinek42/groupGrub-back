class ChangeRestaurantCuisinesToJson < ActiveRecord::Migration[7.0]
  def change 
    remove_column :restaurants, :cuisines
  end
end
