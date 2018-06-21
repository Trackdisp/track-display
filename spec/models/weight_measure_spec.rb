require 'rails_helper'

RSpec.describe WeightMeasure, type: :model do
  describe '#Relationships' do
    it { should belong_to(:device) }
    it { should belong_to(:campaign) }
    it { should belong_to(:location) }
  end

  describe '#Validations' do
    it { should validate_numericality_of(:item_weight).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:shelf_weight).is_greater_than_or_equal_to(0) }
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

    it 'location_name' do
      expect(subject.location_name).to eq(subject.device.location.name)
    end
  end
end
