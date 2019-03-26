require 'rails_helper'

RSpec.describe WeightMeasure, type: :model do
  describe '#Relationships' do
    it { should belong_to(:device) }
    it { should belong_to(:campaign) }
    it { should belong_to(:location) }
  end

  describe '#Validations' do
    it { should validate_numericality_of(:item_weight).is_greater_than_or_equal_to(0) }
    # it { should validate_numericality_of(:shelf_weight).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:current_weight).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:previous_weight).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:measured_at) }
  end

  describe "#delegate" do
    subject { create(:weight_measure) }

    it 'brand_name' do
      expect(subject.brand_name).to eq(subject.device.location.brand.name)
    end

    it 'campaign_name' do
      expect(subject.campaign_name).to eq(subject.device.campaign.name)
    end

    it 'company_name' do
      expect(subject.company_name).to eq(subject.device.campaign.company.name)
    end

    it 'device_name' do
      expect(subject.device_name).to eq(subject.device.name)
    end

    it 'device_serial' do
      expect(subject.device_serial).to eq(subject.device.serial)
    end

    it 'device_active' do
      expect(subject.device_active).to eq(subject.device.active)
    end

    it 'location_name' do
      expect(subject.location_name).to eq(subject.device.location.name)
    end
  end

  describe 'WeightMeasureIndex' do
    let(:result) { double }
    let(:index_name) { double(:index_name) }
    let(:indices) { double(:indices) }
    let(:client) { double(:client, indices: indices) }
    let(:mappings) { {} }
    let(:settings) { {} }

    let(:elastic) do
      double(
        :elastic,
        client: client,
        index_name: index_name,
        mappings: mappings,
        settings: settings
      )
    end

    before { allow(described_class).to receive(:__elasticsearch__).and_return(elastic) }

    describe '#create_index!' do
      let(:indices) { double(:indices, create: result) }
      let(:options) { {} }
      let(:perform) { described_class.create_index!(options) }

      let(:expected_params) do
        {
          index: index_name,
          body: {
            settings: settings.to_hash,
            mappings: mappings.to_hash
          }
        }
      end

      context 'with empty options' do
        before do
          expect(described_class).not_to receive(:destroy_index!)
          expect(indices).to receive(:create).with(expected_params).and_return(result)
        end

        it { expect(perform).to eq(result) }
      end

      context 'with force option' do
        let(:options) do
          {
            force: true
          }
        end

        before do
          expect(described_class).to receive(:destroy_index!).and_return(true)
          expect(indices).to receive(:create).with(expected_params).and_return(result)
        end

        it { expect(perform).to eq(result) }
      end
    end

    describe '#destroy_index!' do
      let(:indices) { double(:indices, delete: result) }
      let(:perform) { described_class.destroy_index! }

      before { expect(indices).to receive(:delete).with(index: index_name).and_return(result) }

      it { expect(perform).to eq(result) }
    end

    describe '#refresh_index!' do
      let(:indices) { double(:indices, refresh: result) }
      let(:perform) { described_class.refresh_index! }

      before { expect(indices).to receive(:refresh).with(no_args).and_return(result) }

      it { expect(perform).to eq(result) }
    end

    describe '#update_document' do
      let!(:object) { create(:weight_measure) }
      let(:object_id) { object.id }
      let(:perform) { described_class.update_document(object_id) }

      context 'with a new document' do
        before do
          expect_any_instance_of(WeightMeasure).to receive(:update_document).and_return(false)
          expect_any_instance_of(WeightMeasure).to receive(:index_document).and_return(true)
          expect_any_instance_of(WeightMeasure).not_to receive(:delete_document)
        end

        it { expect(perform).to be_nil }
      end

      context 'with a modified document' do
        before do
          expect_any_instance_of(WeightMeasure).to receive(:update_document).and_return(true)
          expect_any_instance_of(WeightMeasure).not_to receive(:index_document)
          expect_any_instance_of(WeightMeasure).not_to receive(:delete_document)
        end

        it { expect(perform).to be_nil }
      end

      context 'with a deleted document' do
        before do
          object.destroy
          expect_any_instance_of(WeightMeasure).not_to receive(:update_document)
          expect_any_instance_of(WeightMeasure).not_to receive(:index_document)
          expect_any_instance_of(WeightMeasure).to receive(:delete_document).and_return(true)
        end

        it { expect(perform).to eq(true) }
      end
    end
  end
end
