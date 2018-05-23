class EsIndex::UpdateCampaignMeasuresJob < EsIndex::BaseJob
  def perform(campaign_id)
    Elastic::IndexUpdater.update_device_measures(campaign_id)
  end
end
