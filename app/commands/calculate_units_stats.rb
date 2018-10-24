class CalculateUnitsStats < PowerTypes::Command.new(:campaign,
  locations: nil, brands: nil, date_group: :day, after_date: nil, before_date: nil, channels: nil,
  communes: nil, regions: nil)
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
    add_date_condition
    add_location_conditions
    add_brand_conditions
    add_channel_conditions
    add_commune_conditions
    add_region_conditions
    query
  end

  def add_date_condition
    query.push(range: { measured_at: date_range_query }) if @after_date || @before_date
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

  def add_region_conditions
    region_options = @regions&.reduce(Array.new) do |arr, region|
      arr.push(term: { region_id: region.id })
    end
    query.push(bool: { should: region_options }) if region_options
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

  def query
    @query ||= [
      { term: { campaign_id: @campaign.id } },
      { term: { device_active: true } },
      { range: { items_count: { gt: 0 } } }
    ]
  end
end
