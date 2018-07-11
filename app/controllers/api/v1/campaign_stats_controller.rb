class Api::V1::CampaignStatsController < Api::V1::BaseController
  def index
    render json: ObtainCampaignStats.for(campaign: campaign), status: :ok
  end

  private

  def campaign
    if params.permit(:campaign_id)[:campaign_id]
      @campaign ||= Campaign.find(params.permit(:campaign_id)[:campaign_id])
    end
  end
end
