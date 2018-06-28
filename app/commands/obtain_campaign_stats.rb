class ObtainCampaignStats < PowerTypes::Command.new(:campaign, date_group: :day)
  def perform
    measures = EsSearchMeasures.for(campaign: @campaign).records
    measures_data = group_measures(measures)
    {
      graph_data: measures_data,
      summation: {
        contacts: measures_data[:contacts].values.sum,
        total: measures_data[:total].values.sum
      }
    }
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
end
