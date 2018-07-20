require 'rails_helper'

describe ObtainCampaignStats do
  def perform(*_args)
    described_class.for(*_args)
  end

  before do
    Timecop.freeze(Time.local(2018, 6, 18, 12, 0, 0))
  end

  after do
    Timecop.return
  end

  describe '#perform' do
    let(:campaign) { create(:campaign) }
    let(:location) { create(:location) }
    let(:after_date) { Time.now - 11.days }
    let(:before_date) { Time.now }
    let(:gender) { 'male' }
    let(:device) { create(:device, campaign: campaign, location: location) }
    let!(:measures) do
      [
        create(:measure, device: device, contact_duration: 3, measured_at: 10.days.ago),
        create(:measure, device: device, contact_duration: 6, measured_at: 9.days.ago),
        create(:measure, device: device, contact_duration: 8, measured_at: 5.days.ago),
        create(:measure, device: device, contact_duration: 3, measured_at: 5.days.ago + 2.hour),
        create(:measure, device: device, contact_duration: 4, measured_at: 3.days.ago)
      ]
    end

    let(:search_params) do
      {
        campaign: campaign,
        location: location,
        after_date: after_date,
        before_date: before_date
      }
    end

    let(:measure_search_params) { search_params.merge(gender: gender) }

    let(:unit_rotated_data) { double }
    let(:unit_rotated_sum) { 20 }

    before do
      search = double
      expect(EsSearchMeasures).to receive(:for).with(measure_search_params)
                                               .and_return(search)
      expect(CalculateUnitsRotated).to receive(:for)
        .with(search_params).and_return(data: unit_rotated_data, sum: unit_rotated_sum)
      expect(search).to receive(:records).and_return(device.measures)
    end

    it 'calls EsSearchMeasures and CalculateUnitsRotated commands' do
      perform(measure_search_params)
    end

    it 'calculates campaign stats' do
      stats = perform(measure_search_params)
      expect(stats.campaign).to eq(campaign)
      expect(stats.contacts_data.size).to be(5)
      expect(stats.total_data.size).to be(8)
      expect(stats.contacts_sum).to be(2)
      expect(stats.total_sum).to be(5)
      expect(stats.effectiveness).to be(40)
      expect(stats.units_rotated_data).to be(unit_rotated_data)
      expect(stats.units_rotated_sum).to be(unit_rotated_sum)
    end

    it 'expects defaults to group by day' do
      stats = perform(measure_search_params)
      expect(stats.total_data[10.days.ago.to_date]).to be(1)
      expect(stats.contacts_data[9.days.ago.to_date]).to be(1)
      expect(stats.total_data[9.days.ago.to_date]).to be(1)
      expect(stats.contacts_data[5.days.ago.to_date]).to be(1)
      expect(stats.total_data[5.days.ago.to_date]).to be(2)
      expect(stats.total_data[3.days.ago.to_date]).to be(1)
    end

    it 'groups by week' do
      stats = perform(measure_search_params.merge(date_group: :week))
      expect(stats.total_data[Date.new(2018, 6, 4)]).to be(2)
      expect(stats.contacts_data[Date.new(2018, 6, 4)]).to be(1)
      expect(stats.total_data[Date.new(2018, 6, 11)]).to be(3)
      expect(stats.contacts_data[Date.new(2018, 6, 4)]).to be(1)
    end

    it 'groups by hour' do
      stats = perform(measure_search_params.merge(date_group: :hour))
      expect(stats.total_data[Time.new(2018, 6, 8, 12)]).to be(1)
      expect(stats.contacts_data[Time.new(2018, 6, 9, 12)]).to be(1)
      expect(stats.total_data[Time.new(2018, 6, 9, 12)]).to be(1)
      expect(stats.total_data[Time.new(2018, 6, 13, 12)]).to be(1)
      expect(stats.total_data[Time.new(2018, 6, 13, 14)]).to be(1)
      expect(stats.contacts_data[Time.new(2018, 6, 13, 12)]).to be(1)
      expect(stats.total_data[Time.new(2018, 6, 15, 12)]).to be(1)
    end
  end
end
