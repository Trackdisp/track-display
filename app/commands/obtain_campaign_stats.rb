class ObtainCampaignStats < PowerTypes::Command.new(:campaign)
  def perform
    measures = EsSearchMeasures.for(campaign: @campaign).records
    contacts_data = measures.has_contact.group_by_week(:measured_at).count
    total_data = measures.all.group_by_week(:measured_at).count
    {
      graph_data: {
        contacts: contacts_data,
        total: total_data
      },
      summation: {
        contacts: contacts_data.values.sum,
        total: total_data.values.sum
      }
    }
  end
end
