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

    context 'with after_date params' do
      let(:after_date) { Time.now - 3.days }

      before do
        es_search_params[:query][:bool][:must]
          .push(range: { measured_at: { gte: after_date.strftime('%Y-%m-%d') } })
      end

      it 'filters by location id' do
        expect(Measure).to receive(:es_search).with(es_search_params).and_return(nil)
        perform(campaign: campaign, after_date: after_date)
      end
    end

    context 'with before_date params' do
      let(:before_date) { Time.now }

      before do
        es_search_params[:query][:bool][:must]
          .push(range: { measured_at: { lte: before_date.strftime('%Y-%m-%d') } })
      end

      it 'filters by location id' do
        expect(Measure).to receive(:es_search).with(es_search_params).and_return(nil)
        perform(campaign: campaign, before_date: before_date)
      end
    end
  end
end
