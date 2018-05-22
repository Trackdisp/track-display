class MeasureIndexUpdaterService < PowerTypes::Service.new
  def update_measure(measure_id)
    Measure.update_document(measure_id)
  end
end
