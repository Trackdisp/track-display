require 'rails_helper'

RSpec.describe Company, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :name }
  end

  describe '#Relationships' do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:campaigns).dependent(:destroy) }
    it { should have_many(:devices) }
    it { should have_many(:measures).dependent(:destroy) }
  end
end
