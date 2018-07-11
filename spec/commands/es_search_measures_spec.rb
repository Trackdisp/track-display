require 'rails_helper'

describe EsSearchMeasures do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:es_search_params) do
    {
      query: {
        bool: {
          must: [
            term: { campaign_id: campaign.id }
          ]
        }
      },
      from: 0,
      size: 10000
    }
  end

  describe '#perform' do
    let(:campaign) { create(:campaign) }

    it 'calls es_search on Measure correctly' do
      expect(Measure).to receive(:es_search).with(es_search_params).and_return(nil)
      perform(campaign: campaign)
    end

    context 'with location params' do
      let(:location) { create(:location) }

      before do
        es_search_params[:query][:bool][:must].push(term: { location_id: location.id })
      end

      it 'filters by location id' do
        expect(Measure).to receive(:es_search).with(es_search_params).and_return(nil)
        perform(campaign: campaign, location: location)
      end
    end
  end
end
