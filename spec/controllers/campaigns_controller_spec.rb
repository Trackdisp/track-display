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

    describe "without selected filters" do
      it "returns http success" do
        get :show, params: { slug: campaign.slug }
        expect(response).to have_http_status(:success)
      end

      it "filters values are empty" do
        get :show, params: { slug: campaign.slug }
        expect(assigns(:selected_locations)).to match_array(Set.new)
        expect(assigns(:selected_brands)).to match_array(Set.new)
        expect(assigns(:selected_channels)).to match_array(Set.new)
        expect(assigns(:selected_communes)).to match_array(Set.new)
        expect(assigns(:selected_regions)).to match_array(Set.new)
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

    describe "with selected locations" do
      it "location filter values are the ones sent" do
        get :show, params: { slug: campaign.slug, locations: [measures[0].location_id,
                                                              measures[2].location_id] }
        expect(assigns(:selected_locations)).to match_array(Set.new([measures[0].location,
                                                                     measures[2].location]))
      end
    end

    describe "with selected brands" do
      it "location filter options are only of sent brands" do
        get :show, params: { slug: campaign.slug, brands: [measures[0].location.brand_id,
                                                           measures[2].location.brand_id] }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location])
      end

      it "brand filter values are the ones sent" do
        get :show, params: { slug: campaign.slug, brands: [measures[0].location.brand_id,
                                                           measures[2].location.brand_id] }
        expect(assigns(:selected_brands)).to match_array(Set.new([measures[0].location.brand,
                                                                  measures[2].location.brand]))
      end
    end

    describe "with selected channels" do
      it "location filter options are only of sent channels" do
        get :show, params: { slug: campaign.slug, channels: ["supermarket", "traditional"] }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location])
      end

      it "channel filter values are the ones sent" do
        get :show, params: { slug: campaign.slug, channels: ["supermarket", "traditional"] }
        expect(assigns(:selected_channels)).to match_array(Set.new(["supermarket", "traditional"]))
      end
    end

    describe "with selected communes" do
      it "location filter options are only of sent communes" do
        get :show, params: { slug: campaign.slug, communes: [measures[0].location.commune_id,
                                                             measures[2].location.commune_id] }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location])
      end

      it "commune filter values are the ones sent" do
        get :show, params: { slug: campaign.slug, communes: [measures[0].location.commune_id,
                                                             measures[2].location.commune_id] }
        expect(assigns(:selected_communes)).to match_array(Set.new([measures[0].location.commune,
                                                                    measures[2].location.commune]))
      end
    end

    describe "with selected regions" do
      it "location filter options are only of sent regions" do
        get :show, params: { slug: campaign.slug, regions:
          [measures[0].location.commune.region_id, measures[2].location.commune.region_id] }
        expect(assigns(:locations)).to match_array([measures[0].location, measures[2].location])
      end

      it "commune filter options are only of sent regions" do
        get :show, params: { slug: campaign.slug, regions:
          [measures[0].location.commune.region_id, measures[2].location.commune.region_id] }
        expect(assigns(:communes)).to match_array([measures[0].location.commune,
                                                   measures[2].location.commune])
      end

      it "region filter values are the ones sent" do
        get :show, params: { slug: campaign.slug, regions:
          [measures[0].location.commune.region_id, measures[2].location.commune.region_id] }
        expect(assigns(:selected_regions)).to match_array(
          Set.new([measures[0].location.commune.region, measures[2].location.commune.region])
        )
      end
    end
  end
end
