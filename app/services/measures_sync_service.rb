class MeasuresSyncService < PowerTypes::Service.new
  SYNCHRONIZATION_INTERVAL = ENV.fetch('SYNCHRONIZATION_INTERVAL', 15).to_i

  def sync_since_last
    last_sync = MeasuresSync.completed.by_to_date.first
    from_date = if last_sync.nil?
                  SYNCHRONIZATION_INTERVAL.minutes.ago
                elsif last_sync.to_date > Time.current
                  last_sync.created_at
                else
                  last_sync.to_date
                end
    to_date = from_date + SYNCHRONIZATION_INTERVAL.minutes
    sync_measures(from_date: from_date, to_date: to_date)
  end

  def sync_measures(from_date:, to_date:)
    @sync = MeasuresSync.create!(from_date: from_date, to_date: to_date)
    @sync.execute
    w_measures = FetchMeasures.for(from: from_date, to: to_date)
    unless w_measures.empty?
      measures = w_measures.group_by { |ms| ms[:device_id] }
      measures.each do |dev_serial, dev_measures|
        device = Device.find_or_create_by!(serial: dev_serial)
        import_measures(device, dev_measures)
      end
    end
    @sync.complete
  end

  private

  def import_measures(device, measures)
    measures.each do |measure_data|
      create_or_find_measure(device, measure_data)
    end
  end

  def create_or_find_measure(device, measure_data)
    measure = Measure.find_by(w_id: measure_data[:id])
    unless measure.present?
      device.measures.create(
        w_id: measure_data[:id],
        measured_at: measure_data[:timestamp].to_time,
        avg_age: measure_data[:average_age].to_f,
        presence_duration: measure_data[:total_seconds].to_i,
        contact_duration: measure_data[:total_view_seconds].to_i,
        gender: measure_data[:gender].to_sym,
        happiness: measure_data[:happiness].to_f,
        measures_sync: @sync
      )
    end
  end
end
