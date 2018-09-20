class CalculateUnitsStats < PowerTypes::Command.new(:campaign,
  location: nil, date_group: :day, after_date: nil, before_date: nil)
  ES_SEARCH_SIZE = 10000
  TIME_FORMAT = '%Y-%m-%d'

  def perform
    WeightMeasure.es_search query_definition
  end

  private

  def query_definition
    {
      query: { bool: { must: build_must_definition } },
      aggs: build_aggs_definitions,
      from: 0,
      size: ES_SEARCH_SIZE
    }
  end

  def build_must_definition
    query = [
      { term: { campaign_id: @campaign.id } },
      { term: { device_active: true } },
      { range: { items_count: { gt: 0 } } }
    ]
    query.push(term: { location_id: @location.id }) if @location.present?
    query.push(range: { measured_at: date_range_query }) if @after_date || @before_date
    query
  end

  def build_aggs_definitions
    aggs = {
      units_extracted_sum: { sum: { field: :items_count } },
      units_extracted: {
        date_histogram: {
          field: :measured_at,
          interval: @date_group,
          min_doc_count: 1
        },
        aggs: { items_by_date: { sum: { field: :items_count } } }
      }
    }
    if Time.now.getlocal.zone != 'UTC'
      aggs[:units_extracted][:date_histogram][:time_zone] = "#{Time.now.getlocal.zone}:00"
    end
    aggs.merge(rotation_aggs)
  end

  def rotation_aggs
    {
      by_device: {
        terms: { field: :device_id },
        aggs: {
          rotated_by_device: { sum: { field: :rotated_fraction } }
        }
      },
      sum_rotation: {
        sum_bucket: {
          buckets_path: "by_device>rotated_by_device"
        }
      }
    }
  end

  def date_range_query
    range_query = {}
    range_query[:lte] = @before_date.localtime.strftime(TIME_FORMAT) if @before_date.present?
    range_query[:gte] = @after_date.localtime.strftime(TIME_FORMAT) if @after_date.present?
    range_query
  end
end
