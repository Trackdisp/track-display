class MeasuresSyncJob < ApplicationJob
  queue_as :default

  def perform
    MeasuresSyncService.new.sync_since_last
  end
end
