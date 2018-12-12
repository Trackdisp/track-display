class CampaignsController < BaseController
  include CampaignFiltered

  def index
    @stats = {}
    current_user.company.campaigns.each do |campaign|
      @stats[campaign.id] = ObtainCampaignStats.for(campaign: campaign)
    end
  end

  def show
    @campaign_stat = obtain_campaign_stat
    set_filters_options
  end

  private

  def set_filters_options
    location_options
    brand_options
    channel_options
    region_options
    commune_options
  end

  def brand_options
    @brands ||= Brand.where(id: all_campaign_locations.pluck(:brand_id).compact.uniq)
  end

  def channel_options
    @channels ||= all_campaign_locations.reduce(Set.new) do |arr, loc|
      arr.add(name: t("enumerize.channel.#{loc.channel}"), id: loc.channel) if loc.channel
    end
    @channels ||= []
  end

  def region_options
    @regions ||= Region.where(id: all_campaign_locations.map(&:region_id).uniq)
  end
end
