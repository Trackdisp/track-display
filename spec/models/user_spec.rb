require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#Relationships' do
    it { should belong_to(:company) }
  end
end
