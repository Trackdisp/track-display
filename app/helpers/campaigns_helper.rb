module CampaignsHelper
  def campaign_graph_data(campaign_data)
    [
      { name: I18n.t('messages.campaigns.total_people'), data: campaign_data.total_data },
      { name: I18n.t('messages.campaigns.contacts'), data: contacts_data_extended(campaign_data) },
      { name: I18n.t('messages.campaigns.units_rotated'), data: campaign_data.units_rotated_data }
    ]
  end

  def contacts_data_extended(campaign_data)
    Array.new(campaign_data.contacts_data.length) do |i|
      {
        x: campaign_data.contacts_data[i][0],
        y: campaign_data.contacts_data[i][1],
        female: campaign_data.female_data[i],
        male: campaign_data.male_data[i]
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

  def summary_stats_elements(campaign_stat)
    [
      { icon: 'contacts.svg', value: campaign_stat.contacts_sum, translation: 'contacts' },
      { icon: 'seen.svg', value: campaign_stat.total_sum, translation: 'total_people',
        class: 'total-people' },
      { icon: 'rotation.svg', value: campaign_stat.units_rotated_sum,
        translation: 'units_rotated', class: 'units-rotated' },
      { icon: 'rotation.svg', value: campaign_stat.effectiveness, translation: 'effectiveness' },
      { icon: 'rotation.svg', value: campaign_stat.total_happiness, translation: 'happiness' },
      { icon: 'rotation.svg', value: campaign_stat.total_avg_age, translation: 'avg_age' }
    ]
  end
end
