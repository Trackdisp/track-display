require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :channel }
  end

  describe '#Relations' do
    it { should have_many(:locations) }
    it { should have_many(:measures) }
  end
end
