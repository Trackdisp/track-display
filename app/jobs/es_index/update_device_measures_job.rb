class EsIndex::UpdateDeviceMeasuresJob < EsIndex::BaseJob
  def perform(device_id)
    Elastic::IndexUpdater.update_device_measures(device_id)
  end
end
