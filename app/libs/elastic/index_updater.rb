module Elastic::IndexUpdater
  def self.queue_update_measure(measure_id)
    EsIndex::UpdateMeasureJob.delayed.perform_later(measure_id)
  end

  def self.update_device_measures(device_id)
    update_object_measures(Device, device_id)
  end

  def self.update_company_measures(company_id)
    update_object_measures(Company, company_id)
  end

  def self.update_measure(measure_id)
    Measure.update_document(measure_id)
  end

  private_class_method def self.update_object_measures(klass, object_id)
    object = klass.find_by(id: object_id)
    return unless object
    object.measures.find_each { |measure| queue_update_measure(measure.id) }
    object
  end
end
