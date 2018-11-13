require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do
  describe "GET #get_stats" do
    let(:campaign) { create(:campaign) }
    let(:obtain_stats_response) do
      double(
        total_data: [],
        units_extracted_data: [],
        contacts_data: [],
        contacts_female_data: [],
        contacts_male_data: [],
        avg_age_data: []
      )
    end
    let(:formatted_stats) do
      {
        stats: [
          { name: I18n.t('messages.campaigns.people'), data: obtain_stats_response.total_data },
          { name: I18n.t('messages.campaigns.contacts'), data: [] },
          {
            name: I18n.t('messages.campaigns.extracted'),
            data: obtain_stats_response.units_extracted_data,
            yAxis: 1
          }
        ]
      }
    end
    before do
      expect(ObtainCampaignStats).to receive(:for).and_return(obtain_stats_response)
    end

    it "calls ObtainCampaignStats command" do
      get :get_stats, params: { slug: campaign.slug }
    end

    it "responds with ok status" do
      get :get_stats, params: { slug: campaign.slug }
      expect(response).to have_http_status(:ok)
    end

    it "returns formatted stats" do
      get :get_stats, params: { slug: campaign.slug }
      expect(response.body).to eq(formatted_stats.to_json)
    end
  end
end
