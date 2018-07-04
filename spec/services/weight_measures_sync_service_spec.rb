require 'rails_helper'

describe WeightMeasuresSyncService do
  def build(*_args)
    described_class.new(*_args)
  end

  let(:sync_interval) { ENV.fetch('SYNCHRONIZATION_INTERVAL').to_i }

  before do
    Timecop.freeze(Time.local(2018, 6, 18, 12, 0, 0))
  end

  after do
    Timecop.return
  end

  describe '#sync_since_last' do
    context 'when last sincronization is nil' do
      it 'syncronizes since SYNCHRONIZATION_INTERVAL minutes ago' do
        service = build
        expect(service).to receive(:sync_measures).with(
          from_date: sync_interval.minutes.ago,
          to_date: Time.current
        ).and_return(nil)

        service.sync_since_last
      end
    end

    context 'when last sincronization exists' do
      before do
        last_sync = create(:weight_measures_sync, to_date: Time.current)
        last_sync.execute
        last_sync.complete
      end

      it 'sincronizes since to_date of last syncronization' do
        service = build
        expect(service).to receive(:sync_measures).with(
          from_date: Time.current,
          to_date: sync_interval.minutes.from_now
        ).and_return(nil)

        service.sync_since_last
      end
    end
  end

  describe '#sync_measures' do
    let(:from_date) { sync_interval.minutes.ago }
    let(:to_date) { Time.current }
    let(:wolke_result) do
      [
        { device_id: "1234567890", time: "2018-06-18 15:57:00", item_weight: 10,
          shelf_weight: 89, current_weight: 550, previous_weight: 540 },
        { device_id: "1234567890", time: "2018-06-21 15:59:00", item_weight: 10,
          shelf_weight: 89, current_weight: 550, previous_weight: 540 }
      ]
    end
    let(:perform) { build.sync_measures(from_date: from_date, to_date: to_date) }

    before do
      expect(FetchWeightMeasures).to receive(:for).with(from: from_date, to: to_date)
                                                  .and_return(wolke_result)
    end

    it 'creates syncronization correctly' do
      perform
      expect(WeightMeasuresSync.exists?(from_date: from_date, to_date: to_date)).to be(true)
    end

    it 'creates measures correctly' do
      expect { perform }.to change { WeightMeasure.count }.by(2)
    end
  end
end
