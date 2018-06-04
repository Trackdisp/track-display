require 'rails_helper'

RSpec.describe Device, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :serial }
  end

  describe '#Relationships' do
    it { should have_many(:measures) }
    it { should belong_to(:campaign) }
    it { should belong_to(:location) }
  end

  describe "#delegate" do
    subject { create(:device) }

    it 'brand_name' do
      expect(subject.brand_name).to eq(subject.location.brand.name)
    end

    it 'campaign_name' do
      expect(subject.campaign_name).to eq(subject.campaign.name)
    end
    it 'company_name' do
      expect(subject.company_name).to eq(subject.campaign.company.name)
    end

    it 'location_name' do
      expect(subject.location_name).to eq(subject.location.name)
    end
  end
end
