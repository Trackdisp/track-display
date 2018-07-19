class ObtainCampaignStats < PowerTypes::Command.new(:campaign,
  location: nil, date_group: :day, after_date: nil, before_date: nil, gender: nil)
  def perform
    measures = EsSearchMeasures.for(search_base_params.merge(gender: @gender)).records
    measures_data = group_measures(measures)
    units_rotated = CalculateUnitsRotated.for(search_base_params)
    CampaignStat.new(
      campaign: @campaign,
      contacts_data: measures_data[:contacts],
      total_data: measures_data[:total],
      units_rotated_data: units_rotated[:data],
      units_rotated_sum: units_rotated[:sum]
    )
  end

  private

  def group_measures(measures)
    contact_measures = measures.has_contact
    total_measures = measures.all

    if @date_group == :week
      contact_measures = contact_measures.group_by_week(:measured_at, week_start: :mon)
      total_measures = total_measures.group_by_week(:measured_at, week_start: :mon)
    elsif @date_group == :day
      contact_measures = contact_measures.group_by_day(:measured_at)
      total_measures = total_measures.group_by_day(:measured_at)
    else
      contact_measures = contact_measures.group_by_hour(:measured_at)
      total_measures = total_measures.group_by_hour(:measured_at)
    end

    {
      contacts: contact_measures.count, total: total_measures.count
    }
  end

  def search_base_params
    {
      campaign: @campaign,
      location: @location,
      after_date: @after_date,
      before_date: @before_date
    }
  end
end
