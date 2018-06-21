require 'rails_helper'

describe Elastic::IndexUpdater do
  describe "#update_measure" do
    let(:measure_id) { double }
    let(:perform) { described_class.update_measure(measure_id) }

    before { expect(Measure).to receive(:update_document).with(measure_id).and_return(true) }

    it { expect(perform).to eq(true) }
  end

  describe "#queue_update_measure" do
    let(:measure_id) { double }
    let(:job) { double(perform_later: true) }
    let(:perform) { described_class.queue_update_measure(measure_id) }

    before do
      expect(EsIndex::UpdateMeasureJob).to receive(:delayed).and_return(job)
      expect(job).to receive(:perform_later).with(measure_id)
    end

    it { expect(perform).to eq(true) }
  end

  describe "#update_weight_measure" do
    let(:measure_id) { double }
    let(:perform) { described_class.update_weight_measure(measure_id) }

    before { expect(WeightMeasure).to receive(:update_document).with(measure_id).and_return(true) }

    it { expect(perform).to eq(true) }
  end

  describe "#queue_update_weight_measure" do
    let(:measure_id) { double }
    let(:job) { double(perform_later: true) }
    let(:perform) { described_class.queue_update_weight_measure(measure_id) }

    before do
      expect(EsIndex::UpdateWeightMeasureJob).to receive(:delayed).and_return(job)
      expect(job).to receive(:perform_later).with(measure_id)
    end

    it { expect(perform).to eq(true) }
  end

  describe "#update_device_measures" do
    let!(:device) { create(:device) }
    let!(:m1) { create(:measure, device: device) }
    let!(:m2) { create(:measure, device: device) }
    let!(:m3) { create(:measure) }
    let!(:p1) { create(:weight_measure, device: device) }
    let!(:p2) { create(:weight_measure, device: device) }
    let!(:p3) { create(:weight_measure) }
    let(:perform) { described_class.update_device_measures(device.id) }

    context "with found device" do
      before do
        expect(described_class).to receive(:queue_update_measure).with(m1.id).and_return(true)
        expect(described_class).to receive(:queue_update_measure).with(m2.id).and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p1.id)
                                                                        .and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p2.id)
                                                                        .and_return(true)
      end

      it { expect(perform).to be_a(Device) }
    end

    context "with device not found" do
      before do
        device.destroy
        expect(described_class).not_to receive(:queue_update_measure)
        expect(described_class).not_to receive(:queue_update_weight_measure)
      end

      it { expect(perform).to be_nil }
    end
  end

  describe "#update_company_measures" do
    let!(:company) { create(:company) }
    let!(:campaign) { create(:campaign, company: company) }
    let!(:device) { create(:device, campaign: campaign) }
    let!(:m1) { create(:measure, device: device) }
    let!(:m2) { create(:measure, device: device) }
    let!(:m3) { create(:measure) }
    let!(:p1) { create(:weight_measure, device: device) }
    let!(:p2) { create(:weight_measure, device: device) }
    let!(:p3) { create(:weight_measure) }
    let(:perform) { described_class.update_company_measures(company.id) }

    context "with found company" do
      before do
        expect(described_class).to receive(:queue_update_measure).with(m1.id).and_return(true)
        expect(described_class).to receive(:queue_update_measure).with(m2.id).and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p1.id)
                                                                        .and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p2.id)
                                                                        .and_return(true)
      end

      it { expect(perform).to be_a(Company) }
    end

    context "with company not found" do
      before do
        company.destroy
        expect(described_class).not_to receive(:queue_update_measure)
        expect(described_class).not_to receive(:queue_update_weight_measure)
      end

      it { expect(perform).to be_nil }
    end
  end

  describe "#update_campaign_measures" do
    let!(:campaign) { create(:campaign) }
    let!(:device) { create(:device, campaign: campaign) }
    let!(:m1) { create(:measure, device: device) }
    let!(:m2) { create(:measure, device: device) }
    let!(:m3) { create(:measure) }
    let!(:p1) { create(:weight_measure, device: device) }
    let!(:p2) { create(:weight_measure, device: device) }
    let!(:p3) { create(:weight_measure) }
    let(:perform) { described_class.update_campaign_measures(campaign.id) }

    context "with found campaign" do
      before do
        expect(described_class).to receive(:queue_update_measure).with(m1.id).and_return(true)
        expect(described_class).to receive(:queue_update_measure).with(m2.id).and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p1.id)
                                                                        .and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p2.id)
                                                                        .and_return(true)
      end

      it { expect(perform).to be_a(Campaign) }
    end

    context "with campaign not found" do
      before do
        campaign.destroy
        expect(described_class).not_to receive(:queue_update_measure)
        expect(described_class).not_to receive(:queue_update_weight_measure)
      end

      it { expect(perform).to be_nil }
    end
  end

  describe "#update_location_measures" do
    let!(:location) { create(:location) }
    let!(:device) { create(:device, location: location) }
    let!(:m1) { create(:measure, device: device) }
    let!(:m2) { create(:measure, device: device) }
    let!(:m3) { create(:measure) }
    let!(:p1) { create(:weight_measure, device: device) }
    let!(:p2) { create(:weight_measure, device: device) }
    let!(:p3) { create(:weight_measure) }
    let(:perform) { described_class.update_location_measures(location.id) }

    context "with found location" do
      before do
        expect(described_class).to receive(:queue_update_measure).with(m1.id).and_return(true)
        expect(described_class).to receive(:queue_update_measure).with(m2.id).and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p1.id)
                                                                        .and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p2.id)
                                                                        .and_return(true)
      end

      it { expect(perform).to be_a(Location) }
    end

    context "with location not found" do
      before do
        location.destroy
        expect(described_class).not_to receive(:queue_update_measure)
        expect(described_class).not_to receive(:queue_update_weight_measure)
      end

      it { expect(perform).to be_nil }
    end
  end

  describe "#update_brand_measures" do
    let!(:brand) { create(:brand) }
    let!(:location) { create(:location, brand: brand) }
    let!(:device) { create(:device, location: location) }
    let!(:m1) { create(:measure, device: device) }
    let!(:m2) { create(:measure, device: device) }
    let!(:m3) { create(:measure) }
    let!(:p1) { create(:weight_measure, device: device) }
    let!(:p2) { create(:weight_measure, device: device) }
    let!(:p3) { create(:weight_measure) }
    let(:perform) { described_class.update_brand_measures(brand.id) }

    context "with found brand" do
      before do
        expect(described_class).to receive(:queue_update_measure).with(m1.id).and_return(true)
        expect(described_class).to receive(:queue_update_measure).with(m2.id).and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p1.id)
                                                                        .and_return(true)
        expect(described_class).to receive(:queue_update_weight_measure).with(p2.id)
                                                                        .and_return(true)
      end

      it { expect(perform).to be_a(Brand) }
    end

    context "with brand not found" do
      before do
        brand.destroy
        expect(described_class).not_to receive(:queue_update_measure)
        expect(described_class).not_to receive(:queue_update_weight_measure)
      end

      it { expect(perform).to be_nil }
    end
  end
end
