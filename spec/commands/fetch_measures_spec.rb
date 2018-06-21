require 'rails_helper'

describe FetchMeasures do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:wolke_url) { 'wolke_api_url' }
  let(:wolke_token) { 'wolke_token' }
  let(:conn) { double }

  before do
    Timecop.freeze(Time.local(2018, 6, 18, 12, 0, 0))
    allow(ENV).to receive(:fetch).with('WOLKE_API_URL').and_return(wolke_url)
    allow(ENV).to receive(:fetch).with('WOLKE_TOKEN').and_return(wolke_token)
    allow(Faraday).to receive(:new).and_return(conn)
  end

  after do
    Timecop.return
  end

  describe '#perform' do
    let(:from_date) { 15.minutes.ago }
    let(:to_date) { Time.current }
    let(:api_params) do
      {
        startDate: '2018-06-18T11:45',
        endDate: '2018-06-18T12:00',
        token: wolke_token
      }
    end
    let(:response) { double(body: '[]') }

    before do
      expect(conn).to receive(:get).with(wolke_url, api_params).and_return(response)
    end

    it 'calls the wolke API correctly' do
      result = perform(from: from_date, to: to_date)
      expect(result.is_a?(Array)).to be(true)
    end
  end
end
