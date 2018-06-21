class CreateWeightMeasures < ActiveRecord::Migration[5.1]
  def change
    create_table :weight_measures do |t|
      t.references :device, index: true
      t.references :location, index: true
      t.references :campaign, index: true
      t.datetime :measured_at
      t.integer :item_weight
      t.integer :shelf_weight
      t.integer :current_weight
      t.integer :previous_weight
      t.integer :items_count

      t.timestamps
    end
  end
end
