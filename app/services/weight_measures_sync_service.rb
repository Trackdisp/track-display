class WeightMeasuresSyncService < PowerTypes::Service.new
  SYNCHRONIZATION_INTERVAL = ENV.fetch('SYNCHRONIZATION_INTERVAL', 15).to_i

  def sync_since_last
    last_sync = WeightMeasuresSync.completed.by_to_date.first
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
    @sync = WeightMeasuresSync.create!(from_date: from_date, to_date: to_date)
    @sync.execute
    w_measures = FetchWeightMeasures.for(from: from_date, to: to_date)
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
    measure = WeightMeasure.find_by(
      device_id: device.id, measured_at: measure_data[:time].to_time
    )
    unless measure.present?
      device.weight_measures.create!(
        measured_at: measure_data[:time].to_time,
        item_weight: measure_data[:item_weight].to_i,
        items_max: measure_data[:items_max].to_i,
        shelf_weight: measure_data[:shelf_weight].to_i,
        current_weight: measure_data[:current_weight].to_i,
        previous_weight: measure_data[:previous_weight].to_i,
        weight_measures_sync: @sync
      )
    end
  end
end
