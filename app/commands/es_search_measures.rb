class EsSearchMeasures < PowerTypes::Command.new(:campaign, location: nil, after_date: nil,
                                                            before_date: nil)
  include Elasticsearch::DSL
  ES_SEARCH_SIZE = 10000
  TIME_FORMAT = '%Y-%m-%d'

  def perform
    Measure.es_search query_definition
  end

  private

  def query_definition
    {
      query: { bool: { must: build_must_definition } },
      from: 0,
      size: ES_SEARCH_SIZE
    }
  end

  def build_must_definition
    query = [{ term: { campaign_id: @campaign.id } }]
    query.push(term: { location_id: @location.id }) if @location.present?
    check_date_range(query) if @after_date || @before_date

    query
  end

  def check_date_range(query)
    range_query = {}
    range_query[:lte] = @before_date.localtime.strftime(TIME_FORMAT) if @before_date.present?
    range_query[:gte] = @after_date.localtime.strftime(TIME_FORMAT) if @after_date.present?
    query.push(range: { measured_at: range_query })
  end
end
