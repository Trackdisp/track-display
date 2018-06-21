module Elastic::IndexUpdater
  def self.queue_update_measure(measure_id)
    EsIndex::UpdateMeasureJob.delayed.perform_later(measure_id)
  end

  def self.queue_update_weight_measure(measure_id)
    EsIndex::UpdateWeightMeasureJob.delayed.perform_later(measure_id)
  end

  def self.update_brand_measures(brand_id)
    update_object_measures(Brand, brand_id)
  end

  def self.update_campaign_measures(campaign_id)
    update_object_measures(Campaign, campaign_id)
  end

  def self.update_company_measures(company_id)
    update_object_measures(Company, company_id)
  end

  def self.update_device_measures(device_id)
    update_object_measures(Device, device_id)
  end

  def self.update_location_measures(location_id)
    update_object_measures(Location, location_id)
  end

  def self.update_measure(measure_id)
    Measure.update_document(measure_id)
  end

  def self.update_weight_measure(measure_id)
    WeightMeasure.update_document(measure_id)
  end

  private_class_method def self.update_object_measures(klass, object_id)
    object = klass.find_by(id: object_id)
    return unless object
    object.measures.find_each { |measure| queue_update_measure(measure.id) }
    object.weight_measures.find_each { |measure| queue_update_weight_measure(measure.id) }
    object
  end
end
