class AddReferencesCampaignToMeasure < ActiveRecord::Migration[5.1]
  def change
    add_reference :measures, :campaign, index: true
  end

  def data
    Measure.where.not(device: nil).each do |measure|
      measure.update(campaign: measure.device.campaign)
    end
  end
end
