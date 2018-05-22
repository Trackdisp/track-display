class EsIndex::BaseJob < ApplicationJob
  include ActiveJob::Retry.new(
    strategy: :constant,
    limit: 10,
    delay: 60
  )

  INDEX_UPDATE_TIME = 2.minutes

  queue_as :es_index

  def self.delayed
    set(queue: :es_index, wait: INDEX_UPDATE_TIME)
  end

  def index_updater
    @index_updater ||= MeasureIndexUpdaterService.new
  end
end
