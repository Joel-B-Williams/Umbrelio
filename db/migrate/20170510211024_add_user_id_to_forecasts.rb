class AddUserIdToForecasts < ActiveRecord::Migration[5.0]
  def change
  	add_column :forecasts, :user_id, :integer
  end
end
