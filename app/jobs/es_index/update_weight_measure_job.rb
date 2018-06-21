class EsIndex::UpdateWeightMeasureJob < EsIndex::BaseJob
  def perform(measure_id)
    Elastic::IndexUpdater.update_weight_measure(measure_id)
  end
end
