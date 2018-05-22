class AddReferenceCampaignToDevice < ActiveRecord::Migration[5.1]
  def change
    add_reference :devices, :campaign, index: true
  end
end
