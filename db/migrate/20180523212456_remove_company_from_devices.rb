class RemoveCompanyFromDevices < ActiveRecord::Migration[5.1]
  def change
    remove_reference :devices, :company
  end
end
