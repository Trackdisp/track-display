require 'rails_helper'

RSpec.describe Api::V1::StatsController, type: :controller do
  describe "GET #index" do
    let(:campaign) { create(:campaign) }
    before do
      expect(ObtainCampaignStats).to receive(:for).with(campaign: campaign).and_return([])
    end

    it "calls ObtainCampaignStats command" do
      get :index, params: { campaign_id: campaign.id }
    end

    it "responds with ok status" do
      get :index, params: { campaign_id: campaign.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
