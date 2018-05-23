require 'rails_helper'

RSpec.describe Device, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :serial }
  end

  describe '#Relationships' do
    it { should have_many(:measures) }
    it { should belong_to(:campaign) }
  end

  describe "#delegate" do
    subject { create(:device) }

    it { expect(subject.company_name).to eq(subject.campaign.company.name) }
    it { expect(subject.campaign_name).to eq(subject.campaign.name) }
  end
end
