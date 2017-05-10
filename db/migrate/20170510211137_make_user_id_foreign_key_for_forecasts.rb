class MakeUserIdForeignKeyForForecasts < ActiveRecord::Migration[5.0]
  def change
  	add_foreign_key :forecasts, :users, { name: 'user_id' }
  end
end
