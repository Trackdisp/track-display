module CampaignsHelper
  def campaign_graph_data(campaign_data)
    [
      { name: I18n.t('messages.campaigns.total_people'), data: campaign_data.total_data },
      { name: I18n.t('messages.campaigns.contacts'), data: campaign_data.contacts_data }
    ]
  end

  def campaign_date_range(campaign)
    "#{I18n.localize(campaign.start_date, format: :long).upcase} -
      #{I18n.localize(campaign.end_date, format: :long).upcase}"
  end
end
