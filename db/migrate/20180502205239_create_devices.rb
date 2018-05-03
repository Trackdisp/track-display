class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :serial
      t.references :company, index: true

      t.timestamps
    end
  end
end
