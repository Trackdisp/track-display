require 'rails_helper'

RSpec.describe Measure, type: :model do
  describe '#Relationships' do
    it { should belong_to(:device) }
    it { should belong_to(:campaign) }
  end

  describe '#Validations' do
    it do
      should validate_numericality_of(:people_count).is_greater_than_or_equal_to(0)
                                                    .only_integer
                                                    .allow_nil
    end

    it do
      should validate_numericality_of(:views_over_5).is_greater_than_or_equal_to(0)
                                                    .only_integer
                                                    .allow_nil
    end

    it do
      should validate_numericality_of(:views_over_15).is_greater_than_or_equal_to(0)
                                                     .only_integer
                                                     .allow_nil
    end

    it do
      should validate_numericality_of(:views_over_30).is_greater_than_or_equal_to(0)
                                                     .only_integer
                                                     .allow_nil
    end

    it do
      should validate_numericality_of(:male_count).is_greater_than_or_equal_to(0)
                                                  .only_integer
                                                  .allow_nil
    end

    it do
      should validate_numericality_of(:female_count).is_greater_than_or_equal_to(0)
                                                    .only_integer
                                                    .allow_nil
    end

    it do
      should validate_numericality_of(:avg_age).is_greater_than_or_equal_to(0)
                                               .only_integer
                                               .allow_nil
    end

    it do
      should validate_numericality_of(:happy_count).is_greater_than_or_equal_to(0)
                                                   .only_integer
                                                   .allow_nil
    end

    it { should validate_presence_of(:measured_at) }
  end

  describe "#delegate" do
    subject { create(:measure) }

    it { expect(subject.device_name).to eq(subject.device.name) }
    it { expect(subject.device_serial).to eq(subject.device.serial) }
    it { expect(subject.company_name).to eq(subject.device.campaign.company.name) }
    it { expect(subject.campaign_name).to eq(subject.device.campaign.name) }
  end

  describe "MeasureIndex" do
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

    describe "#create_index!" do
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

      context "with empty options" do
        before do
          expect(described_class).not_to receive(:destroy_index!)
          expect(indices).to receive(:create).with(expected_params).and_return(result)
        end

        it { expect(perform).to eq(result) }
      end

      context "with force option" do
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

    describe "#destroy_index!" do
      let(:indices) { double(:indices, delete: result) }
      let(:perform) { described_class.destroy_index! }

      before { expect(indices).to receive(:delete).with(index: index_name).and_return(result) }

      it { expect(perform).to eq(result) }
    end

    describe "#refresh_index!" do
      let(:indices) { double(:indices, refresh: result) }
      let(:perform) { described_class.refresh_index! }

      before { expect(indices).to receive(:refresh).with(no_args).and_return(result) }

      it { expect(perform).to eq(result) }
    end

    describe "#update_document" do
      let!(:object) { create(:measure) }
      let(:object_id) { object.id }
      let(:perform) { described_class.update_document(object_id) }

      context "with a new document" do
        before do
          expect_any_instance_of(Measure).to receive(:update_document).and_return(false)
          expect_any_instance_of(Measure).to receive(:index_document).and_return(true)
          expect_any_instance_of(Measure).not_to receive(:delete_document)
        end

        it { expect(perform).to be_nil }
      end

      context "with a modified document" do
        before do
          expect_any_instance_of(Measure).to receive(:update_document).and_return(true)
          expect_any_instance_of(Measure).not_to receive(:index_document)
          expect_any_instance_of(Measure).not_to receive(:delete_document)
        end

        it { expect(perform).to be_nil }
      end

      context "with a deleted document" do
        before do
          object.destroy
          expect_any_instance_of(Measure).not_to receive(:update_document)
          expect_any_instance_of(Measure).not_to receive(:index_document)
          expect_any_instance_of(Measure).to receive(:delete_document).and_return(true)
        end

        it { expect(perform).to eq(true) }
      end
    end
  end
end
