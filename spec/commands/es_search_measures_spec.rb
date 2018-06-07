require 'rails_helper'

describe EsSearchMeasures do
  def perform(*_args)
    described_class.for(*_args)
  end

  describe '#perform' do
    let(:campaign) { create(:campaign) }

    it 'calls es_search on Measure correctly' do
      expect(Measure).to receive(:es_search).and_return(nil)
      perform(campaign: campaign)
    end
  end
end
