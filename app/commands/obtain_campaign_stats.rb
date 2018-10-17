class ObtainCampaignStats < PowerTypes::Command.new(:campaign,
  locations: nil, brand: nil, date_group: :day, after_date: nil, before_date: nil, gender: nil,
  channel: nil, commune: nil, region: nil)
  def perform
    measures = parse_measures_stats(
      CalculateMeasuresStats.for(search_params.merge(gender: @gender))
    )
    units_extracted = parse_units_stats(CalculateUnitsStats.for(search_params))
    CampaignStat.new(
      campaign: @campaign,
      contacts: measures[:contacts],
      total: measures[:total],
      units_extracted: units_extracted
    )
  end

  private

  def parse_measures_stats(es_response)
    contacts = es_response.aggregations.contacts
    total_aggs = es_response.aggregations
    {
      contacts: {
        data: parse_bucket_count(contacts.by_date),
        sum: contacts.doc_count,
        female_data: parse_gender_count(contacts.by_date, "female"),
        female: parse_key_count(contacts.gender_group, "female"),
        male_data: parse_gender_count(contacts.by_date, "male"),
        male: parse_key_count(contacts.gender_group, "male"),
        avg_age_data: parse_avg_age(contacts.by_date)
      },
      total: total_aggregations(total_aggs, es_response.results.count)
    }
  end

  def total_aggregations(total_aggs, sum)
    {
      avg_age: total_aggs.avg_age.value&.round || 0,
      data: parse_bucket_count(total_aggs.by_date),
      female: parse_key_count(total_aggs.gender_group, "female"),
      female_avg_age: parse_key_avg_age(total_aggs.gender_group, "female"),
      female_happiness: parse_key_happiness(total_aggs.gender_group, "female"),
      happiness: total_aggs.avg_happiness.value,
      male: parse_key_count(total_aggs.gender_group, "male"),
      male_avg_age: parse_key_avg_age(total_aggs.gender_group, "male"),
      male_happiness: parse_key_happiness(total_aggs.gender_group, "male"),
      sum: sum
    }
  end

  def parse_units_stats(es_response)
    {
      data: parse_units_count(es_response.aggregations.units_extracted.buckets),
      sum: es_response.aggregations.units_extracted_sum.value.to_i,
      sum_rotation: es_response.aggregations.sum_rotation.value.to_f.round(2)
    }
  end

  def parse_units_count(results)
    results.reduce(Array.new) do |arr, unit_extracted|
      arr.push(
        [
          Time.parse(unit_extracted.key_as_string).to_f * 1000,
          unit_extracted.items_by_date.value.to_i
        ]
      )
    end
  end

  def parse_bucket_count(histogram)
    histogram.buckets.reduce(Array.new) do |arr, bucket|
      arr.push([Time.parse(bucket.key_as_string).to_f * 1000, bucket.doc_count.to_i])
    end
  end

  def parse_gender_count(histogram, gender)
    histogram.buckets.reduce(Array.new) do |arr, bucket|
      g_buck = bucket.gender_group.buckets.find { |gender_bucket| gender_bucket[:key] == gender }
      gender_count = g_buck ? g_buck[:doc_count] : 0
      arr.push(gender_count)
    end
  end

  def parse_avg_age(histogram)
    histogram.buckets.reduce(Array.new) do |arr, bucket|
      arr.push(bucket.avg_age.value&.round || 0)
    end
  end

  def parse_key_count(aggregation, key)
    key_bucket = aggregation.buckets.find { |bucket| bucket[:key] == key }
    key_bucket&.[](:doc_count) || 0
  end

  def parse_key_avg_age(aggregation, key)
    key_bucket = aggregation.buckets.find { |bucket| bucket[:key] == key }
    key_bucket&.[](:avg_age)&.value&.round || 0
  end

  def parse_key_happiness(aggregation, key)
    key_bucket = aggregation.buckets.find { |bucket| bucket[:key] == key }
    key_bucket&.[](:avg_happiness)&.value || 0
  end

  def search_params
    {
      campaign: @campaign,
      locations: @locations,
      channel: @channel,
      brand: @brand,
      commune: @commune,
      region: @region,
      after_date: @after_date,
      before_date: @before_date,
      date_group: @date_group
    }
  end
end
