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
    context 'when last synchronization is nil' do
      it 'syncronizes since SYNCHRONIZATION_INTERVAL minutes ago' do
        service = build
        expect(service).to receive(:sync_measures).with(
          from_date: sync_interval.minutes.ago,
          to_date: Time.current
        ).and_return(nil)

        service.sync_since_last
      end
    end

    context 'when last synchronization exists' do
      context 'and to_date is before Time.current' do
        before do
          last_sync = create(:weight_measures_sync, to_date: Time.current - 1.day)
          last_sync.execute
          last_sync.complete
        end

        it 'synchronizes since to_date of last synchronization' do
          service = build
          expect(service).to receive(:sync_measures).with(
            from_date: Time.current - 1.day,
            to_date: Time.current - 1.day + sync_interval.minutes
          ).and_return(nil)

          service.sync_since_last
        end
      end

      context 'and to_date is after or at Time.current' do
        before do
          last_sync = create(:weight_measures_sync, to_date: Time.current + 1.minute)
          last_sync.execute
          last_sync.complete
        end

        it 'synchronizes since created_at of last synchronization' do
          service = build
          expect(service).to receive(:sync_measures).with(
            from_date: WeightMeasuresSync.last.created_at,
            to_date: WeightMeasuresSync.last.created_at + sync_interval.minutes
          ).and_return(nil)

          service.sync_since_last
        end
      end
    end
  end

  describe '#sync_measures' do
    let(:from_date) { sync_interval.minutes.ago }
    let(:to_date) { Time.current }
    let(:wolke_result) do
      [
        { device_id: "1234567890", timestamp: "2018-06-18 15:57:00", item_weight: 10,
          items_max: 20, shelf_weight: 89, current_weight: 550, previous_weight: 540 },
        { device_id: "1234567890", timestamp: "2018-06-21 15:59:00", item_weight: 10,
          items_max: 20, shelf_weight: 89, current_weight: 550, previous_weight: 540 }
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

    context 'when wolke results is empty' do
      let(:wolke_result) { [] }

      it "doesn't creates new measures " do
        expect { perform }.not_to(change { WeightMeasure.count })
      end

      it 'creates a complete synchronization' do
        expect { perform }.to(change { WeightMeasuresSync.count })
        expect(WeightMeasuresSync.last.state).to eq(:completed)
      end
    end
  end
end
