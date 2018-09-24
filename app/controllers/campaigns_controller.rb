class CampaignsController < BaseController
  def index
    @stats = {}
    current_user.company.campaigns.each do |campaign|
      @stats[campaign.id] = ObtainCampaignStats.for(campaign: campaign)
    end
  end

  def show
    @campaign_stat = ObtainCampaignStats.for(
      after_date: after_date&.to_time,
      before_date: before_date&.to_time,
      campaign: campaign,
      date_group: date_group_by,
      gender: gender,
      location: location,
      brand: brand
    )
    all_locations = Location.find(campaign.devices.where(active: true).pluck(:location_id).uniq)
    @locations = @brand ? all_locations.select { |l| l.brand_id == @brand.id } : all_locations
    @brands = Brand.find(all_locations.pluck(:brand_id).uniq)
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

  def brand
    @brand ||= Brand.find_by(id: params[:brand].to_i) if params[:brand].present?
  end

  def after_date
    @after_date ||= params[:after]
  end

  def before_date
    @before_date ||= params[:before]
  end

  def gender
    @gender ||= params[:gender]
  end
end
