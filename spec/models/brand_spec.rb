require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe '#Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :channel }
  end
end
