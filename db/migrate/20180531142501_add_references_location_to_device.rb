class AddReferencesLocationToDevice < ActiveRecord::Migration[5.1]
  def change
    add_reference :devices, :location, index: true
  end
end
