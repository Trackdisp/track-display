class EsIndex::UpdateLocationMeasuresJob < EsIndex::BaseJob
  def perform(location_id)
    Elastic::IndexUpdater.update_location_measures(location_id)
  end
end
