shared_examples :campaign_filtered do
  subject { described_class.new }

  let(:group_by) { :week }
  let(:after) { '2018-04-14T12:00' }
  let(:before) { '2018-07-14T12:00' }
  let(:gender) { 'female' }
  let(:obtain_campaign_stats_response) { ['some', 'result'] }

  describe "#obtain_campaign_stat" do
    before do
      allow(subject).to receive(:params).and_return(
        slug: campaign.slug,
        locations: locations,
        channels: channels,
        communes: communes,
        regions: regions,
        group_by: group_by,
        after: after,
        before: before,
        gender: gender
      )
      expect(ObtainCampaignStats).to receive(:for)
        .with(
          after_date: subject.after_date&.to_time,
          before_date: subject.before_date&.to_time,
          campaign: subject.campaign,
          date_group: subject.date_group_by,
          gender: subject.gender,
          locations: subject.selected_locations,
          brands: subject.selected_brands,
          channels: subject.selected_channels,
          communes: subject.selected_communes,
          regions: subject.selected_regions
        )
        .and_return(obtain_campaign_stats_response)
    end
    it "calls ObtaignCampaignStats with filter values and returns it's value" do
      expect(subject.obtain_campaign_stat).to eq(obtain_campaign_stats_response)
    end
  end

  describe "#campaign" do
    before { allow(subject).to receive(:params).and_return(slug: campaign.slug) }

    it { expect(subject).to respond_to(:campaign) }
    it "returns correct campaign value" do
      expect(subject.campaign).to eq(campaign)
    end
  end

  describe "#selected_locations" do
    it { expect(subject).to respond_to(:selected_locations) }

    context "when no locations are selected" do
      before { allow(subject).to receive(:params).and_return(slug: campaign.slug) }

      it "returns empty array" do
        expect(subject.selected_locations).to match_array([])
      end
    end

    context "when multiple locations are selected" do
      before do
        allow(subject).to receive(:params).and_return(
          slug: campaign.slug, locations: locations
        )
      end

      it "returns correct location values" do
        expect(subject.selected_locations).to match_array([measures[0].location,
                                                           measures[2].location])
      end
    end
  end

  describe "#selected_brands" do
    it { expect(subject).to respond_to(:selected_brands) }

    context "when no brands are selected" do
      before { allow(subject).to receive(:params).and_return(slug: campaign.slug) }

      it "returns empty array" do
        expect(subject.selected_brands).to match_array([])
      end
    end

    context "when multiple brands are selected" do
      before do
        allow(subject).to receive(:params).and_return(
          slug: campaign.slug, brands: brands
        )
      end

      it "returns correct brand values" do
        expect(subject.selected_brands).to match_array([measures[0].location.brand,
                                                        measures[2].location.brand])
      end
    end
  end

  describe "#selected_channels" do
    it { expect(subject).to respond_to(:selected_channels) }

    context "when no channels are selected" do
      before { allow(subject).to receive(:params).and_return(slug: campaign.slug) }

      it "returns empty array" do
        expect(subject.selected_channels).to match_array([])
      end
    end

    context "when multiple channels are selected" do
      before do
        allow(subject).to receive(:params).and_return(
          slug: campaign.slug, channels: channels
        )
      end

      it "returns correct channel values" do
        expect(subject.selected_channels).to match_array(channels)
      end
    end
  end

  describe "#selected_communes" do
    it { expect(subject).to respond_to(:selected_communes) }

    context "when no communes are selected" do
      before { allow(subject).to receive(:params).and_return(slug: campaign.slug) }

      it "returns empty array" do
        expect(subject.selected_communes).to match_array([])
      end
    end

    context "when multiple communes are selected" do
      before do
        allow(subject).to receive(:params).and_return(
          slug: campaign.slug, communes: communes
        )
      end

      it "returns correct commune values" do
        expect(subject.selected_communes).to match_array([measures[0].location.commune,
                                                          measures[2].location.commune])
      end
    end
  end

  describe "#selected_regions" do
    it { expect(subject).to respond_to(:selected_regions) }

    context "when no regions are selected" do
      before { allow(subject).to receive(:params).and_return(slug: campaign.slug) }

      it "returns empty array" do
        expect(subject.selected_regions).to match_array([])
      end
    end

    context "when multiple regions are selected" do
      before do
        allow(subject).to receive(:params).and_return(
          slug: campaign.slug, regions: regions
        )
      end

      it "returns correct region values" do
        expect(subject.selected_regions).to match_array(
          [measures[0].location.commune.region, measures[2].location.commune.region]
        )
      end
    end
  end
end
