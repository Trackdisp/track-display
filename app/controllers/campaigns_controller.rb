class CampaignsController < BaseController
  def index
    @stats = {}
    current_user.company.campaigns.each do |campaign|
      stats = ObtainCampaignStats.for(campaign: campaign)
      @stats[campaign.id] = {
        total_views: stats.contacts_sum,
        total_people: stats.total_sum
      }
    end
  end

  def show
    @campaign_stat = ObtainCampaignStats.for(campaign: campaign, location: location,
                                             date_group: date_group_by)
    @locations = Location.all.select(:id, :name)
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

  def location
    @location ||= Location.find_by(id: params[:location].to_i) if params[:location].present?
  end
end
