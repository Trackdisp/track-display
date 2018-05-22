require 'rails_helper'

RSpec.describe Device, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :serial }
  end

  describe '#Relationships' do
    it { should have_many(:measures) }
    it { should belong_to(:campaign) }
  end
end
