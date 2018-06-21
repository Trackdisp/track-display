class WeightMeasuresSyncJob < ApplicationJob
  queue_as :default

  def perform
    WeightMeasuresSyncService.new.sync_since_last
  end
end
