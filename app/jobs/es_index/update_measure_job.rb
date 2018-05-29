class EsIndex::UpdateMeasureJob < EsIndex::BaseJob
  def perform(measure_id)
    Elastic::IndexUpdater.update_measure(measure_id)
  end
end
