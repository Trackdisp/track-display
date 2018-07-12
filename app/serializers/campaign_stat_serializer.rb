class CampaignStatSerializer < ActiveModel::Serializer
  attributes :campaign, :contacts_data, :contacts_sum, :total_data, :total_sum, :effectiveness

  def campaign_id
    object.campaign.id
  end

  def campaign_name
    object.campaign.name
  end
end
