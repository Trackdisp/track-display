class CalculateUnitsRotated < PowerTypes::Command.new(:campaign,
  location: nil, date_group: :day, after_date: nil, before_date: nil)
  ES_SEARCH_SIZE = 10000
  TIME_FORMAT = '%Y-%m-%d'

  def perform
    es_result = WeightMeasure.es_search query_definition

    {
      data: parse_count_data(es_result.aggregations.units_rotated.buckets),
      sum: es_result.aggregations.units_rotated_sum.value.to_i
    }
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
    query = [{ term: { campaign_id: @campaign.id } }]
    query.push(term: { location_id: @location.id }) if @location.present?
    query.push(range: { items_count: { gt: 0 } })
    check_date_range(query) if @after_date || @before_date

    query
  end

  def build_aggs_definitions
    {
      units_rotated_sum: { sum: { field: :items_count } },
      units_rotated: {
        date_histogram: {
          field: :measured_at,
          interval: @date_group,
          time_zone: "#{Time.now.getlocal.zone}:00",
          min_doc_count: 1
        },
        aggs: { items_by_date: { sum: { field: :items_count } } }
      }
    }
  end

  def check_date_range(query)
    range_query = {}
    range_query[:lte] = @before_date.localtime.strftime(TIME_FORMAT) if @before_date.present?
    range_query[:gte] = @after_date.localtime.strftime(TIME_FORMAT) if @after_date.present?
    query.push(range: { measured_at: range_query })
  end

  def parse_count_data(results)
    results.reduce(Hash.new) do |hash, unit_rotated|
      hash.merge(unit_rotated.key_as_string => unit_rotated.items_by_date.value.to_i)
    end
  end
end
