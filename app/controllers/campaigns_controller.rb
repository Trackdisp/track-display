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
      locations: selected_locations,
      brands: selected_brands,
      channels: selected_channels,
      commune: commune,
      region: region
    )
    set_filters_options
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

  def set_filters_options
    all_locs = all_campaign_locations

    @locations = all_locs.filtered(build_locations_filters_hash)

    @brands = Brand.find(all_locs.pluck(:brand_id).uniq)
    @channels = all_locs.reduce(Set.new) do |arr, loc|
      arr.add(name: t("enumerize.channel.#{loc.channel}"), id: loc.channel)
    end
    @regions = Region.find(all_locs.map(&:region_id).uniq)
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
    filters[:region_id] = @region.id if @region
    filters[:commune_id] = @commune.id if @commune
    filters[:channels] = @selected_channels unless @selected_channels&.empty?
    filters
  end

  def filtered_communes(all_locs)
    if @region.nil?
      Commune.find(all_locs.pluck(:commune_id).uniq)
    else
      Commune.find(all_locs.pluck(:commune_id).uniq & @region.communes.map(&:id))
    end
  end

  def selected_locations
    @selected_locations ||= Set.new
    params[:locations]&.each do |location|
      @selected_locations.add(Location.find_by(id: location.to_i))
    end
    @selected_locations
  end

  def selected_brands
    @selected_brands ||= Set.new
    params[:brands]&.each do |brand|
      @selected_brands.add(Brand.find_by(id: brand.to_i))
    end
    @selected_brands
  end

  def selected_channels
    @selected_channels ||= Set.new
    @selected_channels.merge(params[:channels]) if params[:channels]
    @selected_channels
  end

  def commune
    @commune ||= Commune.find_by(id: params[:commune].to_i) if params[:commune].present?
  end

  def region
    @region ||= Region.find_by(id: params[:region].to_i) if params[:region].present?
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
