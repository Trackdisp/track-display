require 'rails_helper'

RSpec.describe Measure, type: :model do
  describe '#Relationships' do
    it { should belong_to(:device) }
  end

  describe '#Validations' do
    it do
      should validate_numericality_of(:people_count).is_greater_than_or_equal_to(0)
                                                    .only_integer
                                                    .allow_nil
    end

    it do
      should validate_numericality_of(:views_over_5).is_greater_than_or_equal_to(0)
                                                    .only_integer
                                                    .allow_nil
    end

    it do
      should validate_numericality_of(:views_over_15).is_greater_than_or_equal_to(0)
                                                     .only_integer
                                                     .allow_nil
    end

    it do
      should validate_numericality_of(:views_over_30).is_greater_than_or_equal_to(0)
                                                     .only_integer
                                                     .allow_nil
    end

    it do
      should validate_numericality_of(:male_count).is_greater_than_or_equal_to(0)
                                                  .only_integer
                                                  .allow_nil
    end

    it do
      should validate_numericality_of(:female_count).is_greater_than_or_equal_to(0)
                                                    .only_integer
                                                    .allow_nil
    end

    it do
      should validate_numericality_of(:avg_age).is_greater_than_or_equal_to(0)
                                               .only_integer
                                               .allow_nil
    end

    it do
      should validate_numericality_of(:happy_count).is_greater_than_or_equal_to(0)
                                                   .only_integer
                                                   .allow_nil
    end
  end
end
