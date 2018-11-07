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

    before do
      expect(ObtainCampaignStats).to receive(:for).and_return([])
    end

    context "when no filters are selected" do
      it "returns http success" do
        get :show, params: { slug: campaign.slug }
        expect(response).to have_http_status(:success)
      end

      it "assigns empty arrays to all filter values" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:selected_locations)).to match_array(Array.new)
        expect(assigns(:selected_brands)).to match_array(Array.new)
        expect(assigns(:selected_channels)).to match_array(Array.new)
        expect(assigns(:selected_communes)).to match_array(Array.new)
        expect(assigns(:selected_regions)).to match_array(Array.new)
      end

      it "sets locations filter options considering only active devices from campaign" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location,
                                                    measures[3].location])
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

      it "sets communes filter options considering only those with an associated location in "\
         "the locations filter options" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:communes)).to match_array([measures[0].location.commune,
                                                   measures[2].location.commune,
                                                   measures[3].location.commune])
      end

      it "sets regions filter options considering only those with an associated location in "\
         "the locations filter options" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:regions)).to match_array([measures[0].location.commune.region,
                                                  measures[2].location.commune.region,
                                                  measures[3].location.commune.region])
      end
    end

    context "when multiple locations are selected" do
      let(:locations) { [measures[0].location_id, measures[2].location_id] }

      it "assigns correct location values" do
        get :show, params: { slug: campaign.slug, locations: locations }
        expect(assigns(:selected_locations)).to match_array([measures[0].location,
                                                             measures[2].location])
      end
    end

    context "when multiple brands are selected" do
      let(:brands) { [measures[0].location.brand_id, measures[2].location.brand_id] }

      it "sets location filter options considering only those of selected brands" do
        get :show, params: { slug: campaign.slug, brands: brands }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location])
      end

      it "assigns correct brand values" do
        get :show, params: { slug: campaign.slug, brands: brands }
        expect(assigns(:selected_brands)).to match_array([measures[0].location.brand,
                                                          measures[2].location.brand])
      end
    end

    context "when multiple channels are selected" do
      let(:channels) { ["supermarket", "traditional"] }

      it "sets location filter options considering only those of selected channels" do
        get :show, params: { slug: campaign.slug, channels: channels }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location])
      end

      it "assigns correct channel values" do
        get :show, params: { slug: campaign.slug, channels: channels }
        expect(assigns(:selected_channels)).to match_array(channels)
      end
    end

    context "when multiple communes are selected" do
      let(:communes) { [measures[0].location.commune_id, measures[2].location.commune_id] }

      it "sets location filter options considering only those of selected communes" do
        get :show, params: { slug: campaign.slug, communes: communes }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location])
      end

      it "assigns correct commune values" do
        get :show, params: { slug: campaign.slug, communes: communes }
        expect(assigns(:selected_communes)).to match_array([measures[0].location.commune,
                                                            measures[2].location.commune])
      end
    end

    context "when multiple regions are selected" do
      let(:regions) do
        [measures[0].location.commune.region_id, measures[2].location.commune.region_id]
      end

      it "sets location filter options considering only those of selected regions" do
        get :show, params: { slug: campaign.slug, regions: regions }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location])
      end

      it "sets commune filter options considering only those of selected regions" do
        get :show, params: { slug: campaign.slug, regions: regions }
        expect(assigns(:communes)).to match_array([measures[0].location.commune,
                                                   measures[2].location.commune])
      end

      it "assigns correct region values" do
        get :show, params: { slug: campaign.slug, regions: regions }
        expect(assigns(:selected_regions)).to match_array(
          [measures[0].location.commune.region, measures[2].location.commune.region]
        )
      end
    end
  end
end
