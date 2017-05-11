class CreateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :forecasts do |t|
    	t.string "lat", 	null: false
    	t.string "lng", null: false
    	t.string "location", 	null: false

      t.timestamps
    end
  end
end
