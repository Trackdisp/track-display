require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do
  describe "GET #dependant_filters_options" do
    let(:campaign) { create(:campaign) }
    let(:locations) { [create(:location), create(:location)].to_json }
    let(:communes) { [create(:commune), create(:commune)].to_json }

    before do
      expect(subject).to receive(:location_options).and_return(locations)
      expect(subject).to receive(:commune_options).and_return(communes)
    end

    it "responds with ok status" do
      get :dependant_filters_options, params: { slug: campaign.slug }
      expect(response).to have_http_status(:ok)
    end

    it "responds with location and commune options" do
      get :dependant_filters_options, params: { slug: campaign.slug }
      expected = { "locations[]": locations, "communes[]": communes }.to_json
      expect(response.body).to eq(expected)
    end
  end
end
