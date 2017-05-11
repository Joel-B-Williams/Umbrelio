class AddLocationToForecasts < ActiveRecord::Migration[5.0]
  def change
  	add_column :forecasts, :location, :string
  end
end
