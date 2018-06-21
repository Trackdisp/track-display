class CreateMeasuresSyncs < ActiveRecord::Migration[5.1]
  def change
    create_table :measures_syncs do |t|
      t.string :state
      t.datetime :from_date
      t.datetime :to_date
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
