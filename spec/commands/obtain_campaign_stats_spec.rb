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
    let(:contacts_date_01) { '2018-03-11T00:00:00.000-03:00' }
    let(:contacts_date_02) { '2018-03-14T00:00:00.000-03:00' }
    let(:total_date_01) { '2018-03-12T00:00:00.000-03:00' }
    let(:total_date_02) { '2018-03-15T00:00:00.000-03:00' }
    let(:units_date_01) { '2018-03-13T00:00:00.000-03:00' }
    let(:units_date_02) { '2018-03-16T00:00:00.000-03:00' }
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

    let(:unit_extracted_data) { double }
    let(:unit_extracted_sum) { 20 }

    let(:measures_results) do
      double(
        results: double(count: 8),
        aggregations: double(
          contacts: double(
            by_date: double(
              buckets: [
                double(
                  key_as_string: contacts_date_01,
                  doc_count: 1,
                  avg_age: double(value: 26.7),
                  gender_group: double(buckets: [{ key: 'female', doc_count: 1 }])
                ),
                double(
                  key_as_string: contacts_date_02,
                  doc_count: 3,
                  avg_age: double(value: 31.1),
                  gender_group: double(buckets: [{ key: 'male', doc_count: 2 }])
                )
              ]
            ),
            gender_group: double(
              buckets: [
                { key: 'female', doc_count: 1 },
                { key: 'male', doc_count: 2 }
              ]
            ),
            doc_count: 4
          ),
          by_date: double(
            buckets: [
              double(key_as_string: total_date_01, doc_count: 3),
              double(key_as_string: total_date_02, doc_count: 5)
            ]
          ),
          avg_age: double(value: 22.2),
          avg_happiness: double(value: 0.12),
          gender_group: double(
            buckets: [
              { key: 'female', doc_count: 6, avg_age: double(value: 25.1),
                avg_happiness: double(value: 0.41) },
              { key: 'male', doc_count: 2, avg_age: double(value: 30.9),
                avg_happiness: double(value: 0.02) }
            ]
          )
        )
      )
    end

    let(:units_result) do
      double(
        aggregations: double(
          units_extracted: double(
            buckets: [
              double(key_as_string: units_date_01, items_by_date: double(value: 5)),
              double(key_as_string: units_date_02, items_by_date: double(value: 8))
            ]
          ),
          units_extracted_sum: double(value: 10),
          sum_rotation: double(value: 5.3)
        )
      )
    end

    before do
      expect(CalculateMeasuresStats).to receive(:for)
        .with(measure_search_params).and_return(measures_results)
      expect(CalculateUnitsStats).to receive(:for).with(search_params).and_return(units_result)
    end

    it 'calls calculates stats commands' do
      perform(measure_search_params)
    end

    it 'calculates campaign stats' do
      stats = perform(measure_search_params)
      expect(stats.campaign).to eq(campaign)
      expect(stats.contacts_data).to eq(
        [
          [Time.parse(contacts_date_01).to_f * 1000, 1],
          [Time.parse(contacts_date_02).to_f * 1000, 3]
        ]
      )
      expect(stats.contacts_sum).to be(4)
      expect(stats.contacts_female_data).to eq([1, 0])
      expect(stats.contacts_male_data).to eq([0, 2])
      expect(stats.contacts_female_sum).to eq(1)
      expect(stats.contacts_male_sum).to eq(2)
      expect(stats.avg_age_data).to eq([27, 31])
      expect(stats.total_avg_age).to be(22)
      expect(stats.total_female_sum).to be(6)
      expect(stats.total_male_sum).to be(2)
      expect(stats.total_female_avg_age).to be(25)
      expect(stats.total_male_avg_age).to be(31)
      expect(stats.total_data).to eq(
        [
          [Time.parse(total_date_01).to_f * 1000, 3],
          [Time.parse(total_date_02).to_f * 1000, 5]
        ]
      )
      expect(stats.total_sum).to be(8)
      expect(stats.total_happiness).to be(12)
      expect(stats.total_female_happiness).to be(41)
      expect(stats.total_male_happiness).to be(2)
      expect(stats.units_extracted_data).to eq(
        [
          [Time.parse(units_date_01).to_f * 1000, 5],
          [Time.parse(units_date_02).to_f * 1000, 8]
        ]
      )
      expect(stats.units_extracted_sum).to be(10)
      expect(stats.sum_rotation).to be(5.3)
      expect(stats.effectiveness).to be(50)
      expect(stats.female_effectiveness).to be(17)
      expect(stats.male_effectiveness).to be(100)
    end
  end
end
