class EsIndex::UpdateCampaignMeasuresJob < EsIndex::BaseJob
  def perform(campaign_id)
    Elastic::IndexUpdater.update_campaign_measures(campaign_id)
  end
end
