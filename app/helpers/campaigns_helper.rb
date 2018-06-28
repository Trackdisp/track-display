module CampaignsHelper
  def campaign_graph_data(graphs_data)
    [
      { name: I18n.t('messages.campaigns.total_people'), data: graphs_data[:total] },
      { name: I18n.t('messages.campaigns.contacts'), data: graphs_data[:contacts] }
    ]
  end

  def campaign_date_range(campaign)
    "#{I18n.localize(campaign.start_date, format: :long).upcase} -
      #{I18n.localize(campaign.end_date, format: :long).upcase}"
  end
end
