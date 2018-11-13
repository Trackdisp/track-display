require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do
  let!(:campaign) { create(:campaign) }
  let!(:other_campaign) { create(:campaign) }
  let!(:measures) do
    [
      create(:measure,
        device: create(:device,
          active: true, location: create(:location, channel: "traditional"), campaign: campaign)),
      create(:measure,
        device: create(:device,
          active: false, location: create(:location, channel: "local_consumption"),
          campaign: campaign)),
      create(:measure,
        device: create(:device,
          active: true, location: create(:location, channel: "supermarket"), campaign: campaign)),
      create(:measure,
        device: create(:device,
          active: true, location: create(:location, channel: "local_consumption"),
          campaign: campaign))
    ]
  end
  let!(:other_meassures) do
    [
      create(:measure,
        device: create(:device,
          active: true, location: create(:location, channel: "local_consumption"),
          campaign: other_campaign))
    ]
  end
  let(:locations) { [measures[0].location_id, measures[2].location_id] }
  let(:brands) { [measures[0].location.brand_id, measures[2].location.brand_id] }
  let(:channels) { ["supermarket", "traditional"] }
  let(:communes) { [measures[0].location.commune_id, measures[2].location.commune_id] }
  let(:regions) do
    [measures[0].location.commune.region_id, measures[2].location.commune.region_id]
  end

  describe "GET #get_stats" do
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
          { name: I18n.t('messages.campaigns.contacts'), data: obtain_stats_response.total_data },
          {
            name: I18n.t('messages.campaigns.extracted'),
            data: obtain_stats_response.units_extracted_data,
            yAxis: 1
          }
        ]
      }
    end
    before do
      expect(subject).to receive(:obtain_campaign_stat).and_return(obtain_stats_response)
    end

    it "responds with ok status" do
      get :get_stats, params: { slug: campaign.slug }
      expect(response).to have_http_status(:ok)
    end

    it "renders formatted stats" do
      get :get_stats, params: { slug: campaign.slug }
      expect(response.body).to eq(formatted_stats.to_json)
    end
  end

  it_should_behave_like(:campaign_filtered)
end
