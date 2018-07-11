class EsSearchMeasures < PowerTypes::Command.new(:campaign, location: nil)
  include Elasticsearch::DSL
  ES_SEARCH_SIZE = 10000

  def perform
    Measure.es_search query_definition
  end

  private

  def query_definition
    {
      query: { bool: { must: check_campaing_and_location } },
      from: 0,
      size: ES_SEARCH_SIZE
    }
  end

  def check_campaing_and_location
    query = [{ term: { campaign_id: @campaign.id } }]
    query.push(term: { location_id: @location.id }) if @location.present?
    query
  end
end
