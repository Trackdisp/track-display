class ObtainCampaignStats < PowerTypes::Command.new(:campaign,
  location: nil, date_group: :day, after_date: nil, before_date: nil, gender: nil)
  def perform
    measures = parse_measures_stats(
      CalculateMeasuresStats.for(search_params.merge(gender: @gender))
    )
    units_rotated = parse_units_stats(CalculateUnitsRotated.for(search_params))
    CampaignStat.new(
      campaign: @campaign,
      contacts: measures[:contacts],
      total: measures[:total],
      units_rotated: units_rotated
    )
  end

  private

  def parse_measures_stats(es_response)
    contacts = es_response.aggregations.contacts
    total_aggs = es_response.aggregations
    {
      contacts: { data: parse_bucket_count(contacts.by_date), sum: contacts.doc_count },
      total: {
        avg_age: total_aggs.avg_age.value&.round || 0,
        data: parse_bucket_count(total_aggs.by_date),
        female: parse_key_count(total_aggs.gender_group, :female),
        happiness: total_aggs.avg_happiness.value,
        male: parse_key_count(total_aggs.gender_group, :male),
        sum: es_response.results.count
      }
    }
  end

  def parse_units_stats(es_response)
    {
      data: parse_units_count(es_response.aggregations.units_rotated.buckets),
      sum: es_response.aggregations.units_rotated_sum.value.to_i
    }
  end

  def parse_units_count(results)
    results.reduce(Array.new) do |arr, unit_rotated|
      arr.push(
        [
          Time.parse(unit_rotated.key_as_string).to_f * 1000,
          unit_rotated.items_by_date.value.to_i
        ]
      )
    end
  end

  def parse_bucket_count(histogram)
    histogram.buckets.reduce(Array.new) do |arr, bucket|
      arr.push([Time.parse(bucket.key_as_string).to_f * 1000, bucket.doc_count.to_i])
    end
  end

  def parse_key_count(aggregation, key)
    key_bucket = aggregation.buckets.find { |bucket| bucket[:key] == key }
    key_bucket&.doc_count || 0
  end

  def search_params
    {
      campaign: @campaign,
      location: @location,
      after_date: @after_date,
      before_date: @before_date,
      date_group: @date_group
    }
  end
end
