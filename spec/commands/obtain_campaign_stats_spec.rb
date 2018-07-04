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
    let(:device) { create(:device, campaign: campaign) }
    let!(:measures) do
      [
        create(:measure, device: device, contact_duration: 3, measured_at: 10.days.ago),
        create(:measure, device: device, contact_duration: 6, measured_at: 9.days.ago),
        create(:measure, device: device, contact_duration: 8, measured_at: 5.days.ago),
        create(:measure, device: device, contact_duration: 3, measured_at: 5.days.ago + 2.hour),
        create(:measure, device: device, contact_duration: 4, measured_at: 3.days.ago)
      ]
    end

    before do
      search = double
      expect(EsSearchMeasures).to receive(:for).with(campaign: campaign).and_return(search)
      expect(search).to receive(:records).and_return(device.measures)
    end

    it 'calls EsSearchMeasures command' do
      perform(campaign: campaign)
    end

    it 'calculates campaign stats' do
      stats = perform(campaign: campaign)
      expect(stats[:graph_data][:contacts].size).to be(5)
      expect(stats[:graph_data][:total].size).to be(8)
      expect(stats[:summation][:contacts]).to be(2)
      expect(stats[:summation][:total]).to be(5)
      expect(stats[:summation][:effectiveness]).to be(40)
    end

    it 'expects defaults to group by day' do
      stats = perform(campaign: campaign)
      expect(stats[:graph_data][:total][10.days.ago.to_date]).to be(1)
      expect(stats[:graph_data][:contacts][9.days.ago.to_date]).to be(1)
      expect(stats[:graph_data][:total][9.days.ago.to_date]).to be(1)
      expect(stats[:graph_data][:contacts][5.days.ago.to_date]).to be(1)
      expect(stats[:graph_data][:total][5.days.ago.to_date]).to be(2)
      expect(stats[:graph_data][:total][3.days.ago.to_date]).to be(1)
    end

    it 'groups by week' do
      stats = perform(campaign: campaign, date_group: :week)
      expect(stats[:graph_data][:total][Date.new(2018, 6, 4)]).to be(2)
      expect(stats[:graph_data][:contacts][Date.new(2018, 6, 4)]).to be(1)
      expect(stats[:graph_data][:total][Date.new(2018, 6, 11)]).to be(3)
      expect(stats[:graph_data][:contacts][Date.new(2018, 6, 4)]).to be(1)
    end

    it 'groups by hour' do
      stats = perform(campaign: campaign, date_group: :hour)
      expect(stats[:graph_data][:total][Time.new(2018, 6, 8, 12)]).to be(1)
      expect(stats[:graph_data][:contacts][Time.new(2018, 6, 9, 12)]).to be(1)
      expect(stats[:graph_data][:total][Time.new(2018, 6, 9, 12)]).to be(1)
      expect(stats[:graph_data][:total][Time.new(2018, 6, 13, 12)]).to be(1)
      expect(stats[:graph_data][:total][Time.new(2018, 6, 13, 14)]).to be(1)
      expect(stats[:graph_data][:contacts][Time.new(2018, 6, 13, 12)]).to be(1)
      expect(stats[:graph_data][:total][Time.new(2018, 6, 15, 12)]).to be(1)
    end
  end
end
