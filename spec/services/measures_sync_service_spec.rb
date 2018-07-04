require 'rails_helper'

describe MeasuresSyncService do
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
        last_sync = create(:measures_sync, to_date: Time.current)
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
        { id: "5b04db30ee33e37b160111e13", device_id: "1234567890",
          timestamp: "2018-06-18 15:59:00", average_age: 34.9, total_seconds: 15,
          total_view_seconds: 7, gender: "male", happiness: 0.002 },
        { id: "5b04db30ee33e37b160111e14", device_id: "1234567890",
          timestamp: "2018-06-18 16:01:00", average_age: 34.9, total_seconds: 11,
          total_view_seconds: 3, gender: "female", happiness: 0.002 }
      ]
    end
    let(:perform) { build.sync_measures(from_date: from_date, to_date: to_date) }

    before do
      expect(FetchMeasures).to receive(:for).with(from: from_date, to: to_date)
                                            .and_return(wolke_result)
    end

    it 'creates syncronization correctly' do
      perform
      expect(MeasuresSync.exists?(from_date: from_date, to_date: to_date)).to be(true)
    end

    it 'creates measures correctly' do
      expect { perform }.to change { Measure.count }.by(2)
    end
  end
end
