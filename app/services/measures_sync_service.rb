class MeasuresSyncService < PowerTypes::Service.new
  SYNCRONIZATION_INTERVAL = ENV.fetch('SYNCRONIZATION_INTERVAL', 15).to_i

  def sync_since_last
    last_sync = MeasuresSync.completed.by_to_date.first
    from_date = last_sync.nil? ? SYNCRONIZATION_INTERVAL.minutes.ago : last_sync.to_date
    to_date = from_date + SYNCRONIZATION_INTERVAL.minutes
    sync_measures(from_date: from_date, to_date: to_date)
  end

  def sync_measures(from_date:, to_date:)
    @sync = MeasuresSync.create!(from_date: from_date, to_date: to_date)
    @sync.execute
    w_measures = FetchMeasures.for(from: from_date, to: to_date)
    return if w_measures.empty?
    measures = w_measures.group_by { |ms| ms[:device_id] }
    measures.each do |dev_serial, dev_measures|
      device = create_or_find_device(dev_serial)
      import_measures(device, dev_measures)
    end
    @sync.complete
  end

  private

  def import_measures(device, measures)
    measures.each do |measure_data|
      create_or_find_measure(device, measure_data)
    end
  end

  def create_or_find_device(device_serial)
    if device = Device.find_by(serial: device_serial)
      device
    else
      Device.create!(serial: device_serial)
    end
  end

  def create_or_find_measure(device, measure_data)
    measure = Measure.find_by(w_id: measure_data[:id])
    unless measure.present?
      device.measures.create!(
        w_id: measure_data[:id],
        measured_at: measure_data[:timestamp].to_time,
        avg_age: measure_data[:averageAge].to_f,
        presence_duration: measure_data[:totalSeconds].to_i,
        contact_duration: measure_data[:totalViewSeconds].to_i,
        gender: measure_data[:gender].to_sym,
        happiness: measure_data[:happiness].to_f,
        measures_sync: @sync
      )
    end
  end
end
