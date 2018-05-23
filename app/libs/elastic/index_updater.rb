module Elastic::IndexUpdater
  def self.queue_update_measure(measure_id)
    EsIndex::UpdateMeasureJob.delayed.perform_later(measure_id)
  end

  def self.update_measure(measure_id)
    Measure.update_document(measure_id)
  end
end
