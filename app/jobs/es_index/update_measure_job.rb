class EsIndex::UpdateMeasureJob < EsIndex::BaseJob
  def perform(measure_id)
    index_updater.update_measure(measure_id)
  end
end
