module CampaignsHelper
  def campaign_graph_data(campaign_data)
    [
      { name: I18n.t('messages.campaigns.total_people'), data: campaign_data.total_data },
      { name: I18n.t('messages.campaigns.contacts'), data: campaign_data.contacts_data },
      { name: I18n.t('messages.campaigns.units_rotated'), data: campaign_data.units_rotated_data }
    ]
  end

  def campaign_date_range(campaign)
    "#{I18n.localize(campaign.start_date, format: :long).upcase} -
      #{I18n.localize(campaign.end_date, format: :long).upcase}"
  end

  def gender_types_json
    gender_json = []
    Measure::GENDER_TYPES.each do |gender|
      gender_json.push(id: gender, name: I18n.t('enumerize.gender')[gender])
    end
    gender_json.to_json
  end
end
