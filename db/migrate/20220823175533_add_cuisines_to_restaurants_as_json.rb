class AddCuisinesToRestaurantsAsJson < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :cuisines, :json
  end
end
