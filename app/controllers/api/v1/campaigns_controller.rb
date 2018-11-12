class Api::V1::CampaignsController < Api::V1::BaseController
  include CampaignFiltered

  def get_stats
    render json: { stats: campaign_graph_data(obtain_campaign_stat) }, status: :ok
  end

  private

  def campaign_graph_data(campaign_data)
    [
      { name: I18n.t('messages.campaigns.people'), data: campaign_data.total_data },
      { name: I18n.t('messages.campaigns.contacts'), data: contacts_data_extended(campaign_data) },
      {
        name: I18n.t('messages.campaigns.extracted'),
        data: campaign_data.units_extracted_data,
        yAxis: 1
      }
    ]
  end

  def contacts_data_extended(campaign_data)
    Array.new(campaign_data.contacts_data.length) do |i|
      {
        x: campaign_data.contacts_data[i][0],
        y: campaign_data.contacts_data[i][1],
        female: campaign_data.contacts_female_data[i],
        male: campaign_data.contacts_male_data[i],
        avg_age: campaign_data.avg_age_data[i]
      }
    end
  end
end
