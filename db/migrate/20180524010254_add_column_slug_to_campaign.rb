class AddColumnSlugToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :slug, :string
  end

  def data
    Campaign.find_each(&:save)
  end
end
