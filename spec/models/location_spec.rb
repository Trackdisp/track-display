require 'rails_helper'

RSpec.describe Location, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street }
    it { should validate_presence_of :number }
  end

  describe '#Relations' do
    it { should belong_to(:brand) }
    it { should belong_to(:commune) }
    it { should have_many(:devices) }
    it { should have_many(:measures) }
  end

  describe '#delegate' do
    subject { create(:location) }

    it 'brand_name' do
      expect(subject.brand_name).to eq(subject.brand.name)
    end
  end
end
