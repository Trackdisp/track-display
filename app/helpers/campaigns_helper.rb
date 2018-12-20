module CampaignsHelper
  def campaign_graph_data(campaign_data)
    [
      { name: I18n.t('messages.campaigns.people'), data: campaign_data.total_data },
      { name: I18n.t('messages.campaigns.contacts'), data: contacts_data_extended(campaign_data) },
      {
        name: I18n.t('messages.campaigns.extracted'),
        data: campaign_data.units_extracted_data,
        yAxis: 1
      }
    ]
  end

  def contacts_data_extended(campaign_data)
    Array.new(campaign_data.contacts_data.length) do |i|
      {
        x: campaign_data.contacts_data[i][0],
        y: campaign_data.contacts_data[i][1],
        female: campaign_data.contacts_female_data[i],
        male: campaign_data.contacts_male_data[i],
        avg_age: campaign_data.avg_age_data[i]
      }
    end
  end

  def campaign_date_range(campaign)
    "#{I18n.localize(campaign.start_date, format: :short).upcase} -
      #{I18n.localize(campaign.end_date, format: :short).upcase}"
  end

  def gender_types_json
    gender_json = []
    Measure::GENDER_TYPES.each do |gender|
      gender_json.push(id: gender, name: I18n.t('enumerize.gender')[gender])
    end
    gender_json.to_json
  end

  def summary_stats_elements(stat)
    summary_people_stats(stat).concat(
      [
        { icon: 'effectiveness.svg', icon_hover: 'effectiveness-green.svg',
          value: "#{stat.effectiveness}%", translation: 'effectiveness',
          female_value: "#{stat.female_effectiveness}%",
          male_value: "#{stat.male_effectiveness}%" },
        { icon: 'happiness.svg', icon_hover: 'happiness-green.svg',
          value: "#{stat.total_happiness}%", translation: 'happiness',
          female_value: "#{stat.total_female_happiness}%",
          male_value: "#{stat.total_male_happiness}%" },
        { icon: 'age.svg', icon_hover: 'age-green.svg',
          value: stat.total_avg_age, translation: 'age',
          female_value: stat.total_female_avg_age, male_value: stat.total_male_avg_age }
      ]
    ).concat(summary_units_stats(stat))
  end

  def summary_people_stats(stat)
    [
      { icon: 'contacts.svg', icon_hover: 'contacts-green.svg',
        value: stat.contacts_sum, translation: 'contacts',
        female_value: stat.contacts_female_sum, male_value: stat.contacts_male_sum },
      { icon: 'people.svg', icon_hover: 'people-green.svg',
        value: stat.total_sum, translation: 'people',
        female_value: stat.total_female_sum, male_value: stat.total_male_sum,
        class: 'total-people' }
    ]
  end

  def summary_units_stats(stat)
    [
      { icon: 'extracted.svg',
        value: stat.units_extracted_sum, translation: 'extracted',
        class: 'units-extracted' },
      { icon: 'rotation.svg',
        value: stat.sum_rotation, translation: 'rotation',
        class: 'sum-rotation' }
    ]
  end

  def start_date(campaign_data, after)
    return after if after.present?
    min_date_total_data = campaign_data.total_data.map(&:first).min
    min_date_units_extracted_data = campaign_data.units_extracted_data.map(&:first).min
    [min_date_total_data, min_date_units_extracted_data].compact.min
  end

  def end_date(campaign_data, before)
    return before if before.present?
    max_date_total_data = campaign_data.total_data.map(&:first).max
    max_date_units_extracted_data = campaign_data.units_extracted_data.map(&:first).max
    [max_date_total_data, max_date_units_extracted_data].compact.max
  end
end
