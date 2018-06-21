class MeasuresSyncJob < ApplicationJob
  queue_as :default

  def perform
    MeasuresSyncService.sync_since_last
  end
end
