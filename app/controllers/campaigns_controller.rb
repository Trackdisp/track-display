class CampaignsController < BaseController
  def index
    @stats = {}
    current_user.company.campaigns.each do |campaign|
      stats = ObtainCampaignStats.for(campaign: campaign)
      @stats[campaign.id] = {
        total_views: stats[:summation][:contacts],
        total_people: stats[:summation][:total]
      }
    end
  end

  def show
    stats = ObtainCampaignStats.for(campaign: campaign, date_group: date_group_by)
    @graphs_data = stats[:graph_data]
    @campaign_stats = stats[:summation]
  end

  private

  def campaign
    @campaign ||= Campaign.find_by(slug: params[:slug])
  end

  def date_group_by
    @date_group_by ||= begin
      if params[:group_by].present?
        params[:group_by].to_sym
      else
        :day
      end
    end
  end
end
