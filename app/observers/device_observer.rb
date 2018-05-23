class DeviceObserver < PowerTypes::Observer
  after_save :update_es_index

  def update_es_index
    EsIndex::UpdateDeviceMeasuresJob.delayed.perform_later(object.id)
  end
end
