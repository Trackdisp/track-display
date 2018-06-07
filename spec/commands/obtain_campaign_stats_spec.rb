require 'rails_helper'

describe ObtainCampaignStats do
  def perform(*_args)
    described_class.for(*_args)
  end

  describe '#perform' do
    let(:campaign) { create(:campaign) }
    let(:device) { create(:device, campaign: campaign) }
    let!(:measures) do
      [
        create(:measure, device: device, contact_duration: 3),
        create(:measure, device: device, contact_duration: 6),
        create(:measure, device: device, contact_duration: 8),
        create(:measure, device: device, contact_duration: 3),
        create(:measure, device: device, contact_duration: 4)
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
      expect(stats[:graph_data][:contacts].size).to be(1)
      expect(stats[:graph_data][:total].size).to be(1)
      expect(stats[:summation][:contacts]).to be(2)
      expect(stats[:summation][:total]).to be(5)
    end
  end
end
