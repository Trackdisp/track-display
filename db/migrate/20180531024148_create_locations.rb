class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :channel
      t.string :street
      t.integer :number
      t.references :commune, index: true
      t.references :brand, index: true

      t.timestamps
    end
  end
end
