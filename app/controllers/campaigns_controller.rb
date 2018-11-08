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
    all_locs = all_campaign_locations

    @locations = all_locs.filtered(build_locations_filters_hash)

    @brands = Brand.where(id: all_locs.pluck(:brand_id).compact.uniq)
    @channels = all_locs.reduce(Set.new) do |arr, loc|
      arr.add(name: t("enumerize.channel.#{loc.channel}"), id: loc.channel) if loc.channel
    end
    @channels ||= []
    @regions = Region.where(id: all_locs.map(&:region_id).uniq)
    @communes = filtered_communes(all_locs)
  end

  def all_campaign_locations
    measure_locs_ids = campaign.measures.joins(:device).where
                               .not(devices: { active: false },
                                    measures: { location_id: nil })
                               .pluck(:location_id).uniq
    w_measure_locs_ids = campaign.weight_measures.joins(:device).where
                                 .not(devices: { active: false },
                                      weight_measures: { location_id: nil })
                                 .pluck(:location_id).uniq
    all_locs_ids = measure_locs_ids | w_measure_locs_ids

    all_locs_ids ? Location.where(id: all_locs_ids) : nil
  end

  def build_locations_filters_hash
    filters = {}
    filters[:brand_ids] = @selected_brands.map(&:id) unless @selected_brands&.empty?
    filters[:channels] = @selected_channels unless @selected_channels&.empty?
    filters[:commune_ids] = @selected_communes.map(&:id) unless @selected_communes&.empty?
    filters[:region_ids] = @selected_regions.map(&:id) unless @selected_regions&.empty?
    filters
  end

  def filtered_communes(all_locs)
    all_communes_ids = all_locs.pluck(:commune_id).uniq
    if @selected_regions.empty?
      Commune.where(id: all_communes_ids)
    else
      selected_regions_communes_ids = @selected_regions.map(&:communes).flatten.map(&:id)
      Commune.where(id: all_communes_ids & selected_regions_communes_ids)
    end
  end
end
