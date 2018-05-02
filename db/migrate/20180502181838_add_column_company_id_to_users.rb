class AddColumnCompanyIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :company, index: true
  end
end
