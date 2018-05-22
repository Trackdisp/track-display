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
    it { expect(subject.company_name).to eq(subject.device.company.name) }
  end

  describe "MeasureIndex", elasticsearch: true do
    def search
      described_class.es_search(device.company_name)
    end

    let(:device) { create(:device) }
    let!(:m1) { create(:measure, device: device) }
    let!(:m2) { create(:measure, device: device) }

    before { described_class.refresh_index! }

    it { expect(described_class.index_name).to eq("track_display_application-test-measure") }
    it { expect(search.records.count).to eq(2) }

    it "holds valid document's structure" do
      record = search.results.first.to_hash["_source"]
      expect(record["id"]).to eq(m1.id)
      expect(record["device_name"]).to eq(device.name)
      expect(record["device_serial"]).to eq(device.serial)
      expect(record["company_name"]).to eq(device.company_name)
      expect(record["measured_at"]).not_to be_nil
    end

    context "deleting index" do
      before { described_class.destroy_index! }

      it "raises not found index error" do
        expect { described_class.es_search("X").records.count }.to(
          raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
        )
      end
    end
  end
end
