class CalculateMeasuresStats < PowerTypes::Command.new(:campaign,
  locations: nil, brands: nil, date_group: :day, after_date: nil, before_date: nil, gender: nil,
  channels: nil, communes: nil, region: nil)
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
    add_gender_condition
    add_date_condition
    add_location_conditions
    add_brand_conditions
    add_channel_conditions
    add_commune_conditions
    add_region_condition
    query
  end

  def add_gender_condition
    query.push(term: { gender: @gender.to_s }) if @gender.present?
  end

  def add_date_condition
    query.push(range: { measured_at: check_date_range }) if @after_date || @before_date
  end

  def add_location_conditions
    location_options = @locations&.reduce(Array.new) do |arr, location|
      arr.push(term: { location_id: location.id })
    end
    query.push(bool: { should: location_options }) if location_options
  end

  def add_brand_conditions
    brand_options = @brands&.reduce(Array.new) do |arr, brand|
      arr.push(term: { brand_id: brand.id })
    end
    query.push(bool: { should: brand_options }) if brand_options
  end

  def add_channel_conditions
    channel_options = @channels&.reduce(Array.new) do |arr, channel|
      arr.push(term: { channel: channel })
    end
    query.push(bool: { should: channel_options }) if channel_options
  end

  def add_commune_conditions
    commune_options = @communes&.reduce(Array.new) do |arr, commune|
      arr.push(term: { commune_id: commune.id })
    end
    query.push(bool: { should: commune_options }) if commune_options
  end

  def add_region_condition
    query.push(term: { region_id: @region.id }) if @region.present?
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

  def query
    @query ||= [{ term: { campaign_id: @campaign.id } }, { term: { device_active: true } }]
  end
end
