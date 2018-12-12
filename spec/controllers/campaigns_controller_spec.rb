require 'rails_helper'

RSpec.describe CampaignsController, elasticsearch: true, type: :controller do
  login_user
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

  describe "GET #campaign" do
    before do
      expect(ObtainCampaignStats).to receive(:for).and_return([])
    end

    it "returns http success" do
      get :show, params: { slug: campaign.slug }
      expect(response).to have_http_status(:success)
    end

    it "sets brands filter options considering only those with an associated location in "\
        "the locations filter options" do
      get :show, params: { slug: campaign.slug }
      expect(assigns(:brands)).to match_array(
        [measures[0].location.brand, measures[2].location.brand, measures[3].location.brand]
      )
    end

    it "sets channel filter options considering only those present in a location in "\
        "the locations filter options" do
      get :show, params: { slug: campaign.slug }
      expect(assigns(:channels)).to match_array(
        Set.new(
          [
            { id: "supermarket", name: I18n.t("enumerize.channel.supermarket") },
            { id: "traditional", name: I18n.t("enumerize.channel.traditional") },
            { id: "local_consumption", name: I18n.t("enumerize.channel.local_consumption") }
          ]
        )
      )
    end

    it "sets regions filter options considering only those with an associated location in "\
        "the locations filter options" do
      get :show, params: { slug: campaign.slug }
      expect(assigns(:regions)).to match_array([measures[0].location.commune.region,
                                                measures[2].location.commune.region,
                                                measures[3].location.commune.region])
    end
  end

  it_should_behave_like(:campaign_filtered)
end
