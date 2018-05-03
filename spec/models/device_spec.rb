require 'rails_helper'

RSpec.describe Device, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :serial }
  end
end
