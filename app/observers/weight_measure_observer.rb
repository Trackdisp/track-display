class WeightMeasureObserver < PowerTypes::Observer
  after_save :update_es_index
  after_destroy :update_es_index

  def update_es_index
    Elastic::IndexUpdater.queue_update_weight_measure(object.id)
  end
end
