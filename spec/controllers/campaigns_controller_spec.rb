require 'rails_helper'

RSpec.describe CampaignsController, elasticsearch: true, type: :controller do
  describe "GET #campaign" do
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
            active: true, location: create(:location, channel: "supermarket"), campaign: campaign))
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

    before do
      expect(ObtainCampaignStats).to receive(:for).and_return([])
    end

    describe "without selected filters" do
      it "returns http success" do
        get :show, params: { slug: campaign.slug }
        expect(response).to have_http_status(:success)
      end

      it "filters values are nil" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:location)).to eq(nil)
        expect(assigns(:brand)).to eq(nil)
        expect(assigns(:channel)).to eq(nil)
      end

      it "sets locations filter options considering only active devices from campaign" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:locations)).to eq([measures[0].location, measures[2].location])
        expect(assigns(:locations)).not_to include([measures[1].location,
                                                    other_meassures[0].location])
      end

      it "sets brands filter options considering only those with an associated location in "\
         "the locations filter options" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:brands)).to eq([measures[0].location.brand, measures[2].location.brand])
        expect(assigns(:brands)).not_to include([measures[1].location.brand,
                                                 other_meassures[0].location.brand])
      end

      it "sets channel filter options considering only those present in a location in "\
         "the locations filter options" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:channels)).to eq(
          Set.new(
            [
              { id: "supermarket", name: I18n.t("enumerize.channel.supermarket") },
              { id: "traditional", name: I18n.t("enumerize.channel.traditional") }
            ]
          )
        )
      end
    end

    describe "with selected location" do
      it "location filter value is the one sent" do
        get :show, params: { slug: campaign.slug, location: measures[0].location_id }
        expect(assigns(:location)).to eq(measures[0].location)
      end
    end

    describe "with selected brand" do
      it "location filter options are only of sent brand" do
        get :show, params: { slug: campaign.slug, brand: measures[0].location.brand_id }
        expect(assigns(:locations)).to eq([measures[0].location])
      end

      it "brand filter value is the one sent" do
        get :show, params: { slug: campaign.slug, brand: measures[0].location.brand_id }
        expect(assigns(:brand)).to eq(measures[0].location.brand)
      end
    end

    describe "with selected channel" do
      it "location filter options are only of sent channel" do
        get :show, params: { slug: campaign.slug, channel: "supermarket" }
        expect(assigns(:locations)).to eq([measures[2].location])
      end

      it "brand filter value is the one sent" do
        get :show, params: { slug: campaign.slug, channel: "supermarket" }
        expect(assigns(:channel)).to eq("supermarket")
      end
    end
  end
end
