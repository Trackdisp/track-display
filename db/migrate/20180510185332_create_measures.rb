class CreateMeasures < ActiveRecord::Migration[5.1]
  def change
    create_table :measures do |t|
      t.references :device, foreign_key: true
      t.datetime :measured_at
      t.integer :people_count
      t.integer :views_over_5
      t.integer :views_over_15
      t.integer :views_over_30
      t.integer :male_count
      t.integer :female_count
      t.integer :avg_age
      t.integer :happy_count

      t.timestamps
    end
  end
end
