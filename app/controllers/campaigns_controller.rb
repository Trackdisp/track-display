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
    stats = ObtainCampaignStats.for(campaign: campaign)
    @graphs_data = stats[:graph_data]
    @total_views_count = stats[:summation][:contacts]
    @total_people_count = stats[:summation][:total]
    @effectiveness = if @total_people_count != 0
                       (100 * @total_views_count) / @total_people_count
                     else
                       0
                     end
  end

  private

  def campaign
    @campaign ||= Campaign.find_by(slug: params[:slug])
  end
end
