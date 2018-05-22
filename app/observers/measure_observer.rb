class MeasureObserver < PowerTypes::Observer
  after_save :update_es_index
  after_destroy :update_es_index

  def update_es_index
    index_updater.queue_update_measure(object.id)
  end

  private

  def index_updater
    @index_updater ||= MeasureIndexUpdaterService.new
  end
end
