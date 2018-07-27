require 'rails_helper'

describe ObtainCampaignStats do
  def perform(*_args)
    described_class.for(*_args)
  end

  describe '#perform' do
    let(:campaign) { create(:campaign) }
    let(:location) { create(:location) }
    let(:after_date) { Time.now - 11.days }
    let(:before_date) { Time.now }
    let(:gender) { 'male' }
    let(:date_group) { :day }

    let(:search_params) do
      {
        campaign: campaign,
        location: location,
        after_date: after_date,
        before_date: before_date,
        date_group: date_group
      }
    end

    let(:measure_search_params) { search_params.merge(gender: gender) }

    let(:unit_rotated_data) { double }
    let(:unit_rotated_sum) { 20 }

    let(:measures_results) do
      double(
        results: double(count: 8),
        aggregations: double(
          contacts: double(
            by_date: double(
              buckets: [
                double(key_as_string: 'contacts_date_01', doc_count: 1),
                double(key_as_string: 'contacts_date_02', doc_count: 3)
              ]
            ),
            doc_count: 4
          ),
          by_date: double(
            buckets: [
              double(key_as_string: 'total_date_01', doc_count: 3),
              double(key_as_string: 'total_date_02', doc_count: 5)
            ]
          ),
          avg_age: double(value: 22.2),
          avg_happiness: double(value: 0.12),
          gender_group: double(buckets: [{ key: 'female', doc_count: 0 }])
        )
      )
    end

    let(:units_result) do
      double(
        aggregations: double(
          units_rotated: double(
            buckets: [
              double(key_as_string: 'units_date_01', items_by_date: double(value: 5)),
              double(key_as_string: 'units_date_02', items_by_date: double(value: 8))
            ]
          ),
          units_rotated_sum: double(value: 10)
        )
      )
    end

    before do
      expect(CalculateMeasuresStats).to receive(:for)
        .with(measure_search_params).and_return(measures_results)
      expect(CalculateUnitsRotated).to receive(:for).with(search_params).and_return(units_result)
    end

    it 'calls calculates stats commands' do
      perform(measure_search_params)
    end

    it 'calculates campaign stats' do
      stats = perform(measure_search_params)
      expect(stats.campaign).to eq(campaign)
      expect(stats.contacts_data).to eq('contacts_date_01' => 1, 'contacts_date_02' => 3)
      expect(stats.contacts_sum).to be(4)
      expect(stats.effectiveness).to be(50)
      expect(stats.total_avg_age).to be(22)
      expect(stats.total_data).to eq('total_date_01' => 3, 'total_date_02' => 5)
      expect(stats.total_female).to be(0)
      expect(stats.total_male).to be(0)
      expect(stats.total_sum).to be(8)
      expect(stats.units_rotated_data).to eq('units_date_01' => 5, 'units_date_02' => 8)
      expect(stats.units_rotated_sum).to be(10)
    end
  end
end
