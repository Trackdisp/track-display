require 'rails_helper'

RSpec.describe Measure, type: :model do
  describe '#Relationships' do
    it { should belong_to(:device) }
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

  describe "MeasureIndex", elasticsearch: true do
    def search
      described_class.es_search("*")
    end

    def doc
      search.results.first.to_hash["_source"]
    end

    def update_index(measure)
      Measure.update_document(measure.id)
      described_class.refresh_index!
    end

    let(:measure) { create(:measure) }

    before { update_index(measure) }

    it { expect(described_class.index_name).to eq("track_display_application-test-measure") }
    it { expect(search.results.count).to eq(1) }

    it "holds valid document's structure" do
      record = doc
      expect(record["device_name"]).to eq(measure.device_name)
      expect(record["device_serial"]).to eq(measure.device_serial)
      expect(record["campaign_name"]).to eq(measure.campaign_name)
      expect(record["company_name"]).to eq(measure.company_name)
      expect(record["measured_at"]).not_to be_nil
    end

    context "changing attributes" do
      let(:device) { create(:device) }

      before do
        measure.device = device
        measure.save!
        update_index(measure)
      end

      it { expect(doc["device_name"]).to eq(device.name) }
      it { expect(search.results.count).to eq(1) }
    end

    context "deleting document" do
      before do
        measure.destroy!
        update_index(measure)
      end

      it { expect(search.results.count).to eq(0) }
    end

    context "adding a new document" do
      let!(:other_measure) { create(:measure) }

      before { update_index(other_measure) }

      it { expect(search.results.count).to eq(2) }
    end

    context "deleting index" do
      before { described_class.destroy_index! }

      it "raises not found index error" do
        expect { described_class.es_search("X").results.count }.to(
          raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
        )
      end
    end
  end
end
