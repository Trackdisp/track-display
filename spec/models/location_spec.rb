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
  end
end
