module Elastic::IndexUpdater
  def self.queue_update_measure(measure_id)
    EsIndex::UpdateMeasureJob.delayed.perform_later(measure_id)
  end

  def self.update_device_measures(device_id)
    device = Device.find_by(id: device_id)
    return unless device
    device.measures.find_each { |measure| queue_update_measure(measure.id) }
    device
  end

  def self.update_measure(measure_id)
    Measure.update_document(measure_id)
  end
end
