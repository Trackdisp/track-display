module CampaignsHelper
  def campaign_graph_data(campaign_data)
    [
      { name: I18n.t('messages.campaigns.people'), data: campaign_data.total_data },
      { name: I18n.t('messages.campaigns.contacts'), data: contacts_data_extended(campaign_data) },
      { name: I18n.t('messages.campaigns.rotated'), data: campaign_data.units_rotated_data }
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

  def date_format(group_by)
    case group_by
    when "week"
      I18n.t('messages.campaigns.week') + " %A, %b %e, %Y"
    when "day"
      "%A, %b %e, %Y"
    when "hour"
      "%A, %b %e, %H:%M"
    end
  end

  def campaign_date_range(campaign)
    "#{I18n.localize(campaign.start_date, format: :long).upcase} -
      #{I18n.localize(campaign.end_date, format: :long).upcase}"
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
        { icon: 'rotation.svg', value: stat.units_rotated_sum, translation: 'rotated',
          class: 'units-rotated' },
        { icon: 'rotation.svg', value: "#{stat.effectiveness}%", translation: 'effectiveness',
          female_value: "#{stat.female_effectiveness}%",
          male_value: "#{stat.male_effectiveness}%" },
        { icon: 'rotation.svg', value: "#{stat.total_happiness}%", translation: 'happiness',
          female_value: "#{stat.total_female_happiness}%",
          male_value: "#{stat.total_male_happiness}%" },
        { icon: 'rotation.svg', value: stat.total_avg_age, translation: 'age',
          female_value: stat.total_female_avg_age, male_value: stat.total_male_avg_age }
      ]
    )
  end

  def summary_people_stats(stat)
    [
      { icon: 'contacts.svg', value: stat.contacts_sum, translation: 'contacts',
        female_value: stat.contacts_female_sum, male_value: stat.contacts_male_sum },
      { icon: 'seen.svg', value: stat.total_sum, translation: 'people',
        female_value: stat.total_female_sum, male_value: stat.total_male_sum,
        class: 'total-people' }
    ]
  end
end
