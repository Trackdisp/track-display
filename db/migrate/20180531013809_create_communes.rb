class CreateCommunes < ActiveRecord::Migration[5.1]
  def change
    create_table :communes do |t|
      t.string :name
      t.references :region, index: true

      t.timestamps
    end
  end
end
