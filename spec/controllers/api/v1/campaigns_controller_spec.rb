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
  end
end
