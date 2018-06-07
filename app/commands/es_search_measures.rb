class EsSearchMeasures < PowerTypes::Command.new(:campaign)
  include Elasticsearch::DSL
  ES_SEARCH_SIZE = 10000

  def perform
    definition = Search.new
    definition.from = 0
    definition.size = ES_SEARCH_SIZE
    definition.query = Queries::Match.new campaign_name: @campaign.name
    Measure.es_search definition
  end
end
