class CalculateMeasuresStats < PowerTypes::Command.new(:campaign,
  location: nil, date_group: :day, after_date: nil, before_date: nil, gender: nil)
  ES_SEARCH_SIZE = 10000
  TIME_FORMAT = '%Y-%m-%d'

  def perform
    Measure.es_search query_definition
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
    query = [{ term: { campaign_id: @campaign.id } }, { term: { device_active: true } }]
    query.push(term: { location_id: @location.id }) if @location.present?
    query.push(term: { gender: @gender.to_s }) if @gender.present?
    query.push(range: { measured_at: check_date_range }) if @after_date || @before_date
    query
  end

  def build_aggs_definitions
    metrics_aggs.merge(
      contacts: {
        filter: { range: { contact_duration: { gte: 5 } } },
        aggs: metrics_aggs.merge(
          by_date: date_group_agg.merge(
            aggs: metrics_aggs
          )
        )
      },
      by_date: date_group_agg.merge(
        aggs: metrics_aggs
      )
    )
  end

  def metrics_aggs
    {
      avg_age: { avg: { field: :avg_age } },
      avg_happiness: { avg: { field: :happiness } },
      gender_group: {
        terms: { field: :gender, size: 3 },
        aggs: {
          avg_age: { avg: { field: :avg_age } },
          avg_happiness: { avg: { field: :happiness } }
        }
      }
    }
  end

  def date_group_agg
    agg = {
      date_histogram: {
        field: :measured_at,
        interval: @date_group
      }
    }
    if Time.now.getlocal.zone != 'UTC'
      agg[:date_histogram][:time_zone] = "#{Time.now.getlocal.zone}:00"
    end
    agg
  end

  def check_date_range
    range_query = {}
    range_query[:lte] = @before_date.localtime.strftime(TIME_FORMAT) if @before_date.present?
    range_query[:gte] = @after_date.localtime.strftime(TIME_FORMAT) if @after_date.present?
    range_query
  end
end
