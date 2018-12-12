module CampaignFiltered
  extend ActiveSupport::Concern

  included do
    helper_method :campaign, :selected_locations, :selected_brands, :selected_channels,
      :selected_communes, :selected_regions, :date_group_by, :after_date, :before_date, :gender
  end

  def obtain_campaign_stat
    ObtainCampaignStats.for(
      after_date: after_date&.to_time,
      before_date: before_date&.to_time,
      campaign: campaign,
      date_group: date_group_by,
      gender: gender,
      locations: selected_locations,
      brands: selected_brands,
      channels: selected_channels,
      communes: selected_communes,
      regions: selected_regions
    )
  end

  def location_options
    @locations ||= all_campaign_locations.filtered(build_locations_filters_hash)
  end

  def commune_options
    all_communes_ids = all_campaign_locations.pluck(:commune_id).uniq
    @communes ||= if selected_regions.empty?
                    Commune.where(id: all_communes_ids)
                  else
                    selected_regions_communes_ids = selected_regions.map(&:communes)
                                                                    .flatten.map(&:id)
                    Commune.where(id: all_communes_ids & selected_regions_communes_ids)
                  end
  end

  def campaign
    @campaign ||= Campaign.find_by(slug: params[:slug])
  end

  def selected_locations
    @selected_locations ||= Location.where(id: params[:locations]&.map(&:to_i))
  end

  def selected_brands
    @selected_brands ||= Brand.where(id: params[:brands]&.map(&:to_i))
  end

  def selected_channels
    @selected_channels ||= params[:channels].to_a
  end

  def selected_communes
    @selected_communes ||= Commune.where(id: params[:communes]&.map(&:to_i))
  end

  def selected_regions
    @selected_regions ||= Region.where(id: params[:regions]&.map(&:to_i))
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

  def after_date
    @after_date ||= params[:after]
  end

  def before_date
    @before_date ||= params[:before]
  end

  def gender
    @gender ||= params[:gender]
  end

  private

  def all_campaign_locations
    if @all_locs
      @all_locs
    else
      measure_locs_ids = campaign.measures.joins(:device).where
                                 .not(devices: { active: false },
                                      measures: { location_id: nil })
                                 .pluck(:location_id).uniq
      w_measure_locs_ids = campaign.weight_measures.joins(:device).where
                                   .not(devices: { active: false },
                                        weight_measures: { location_id: nil })
                                   .pluck(:location_id).uniq
      all_locs_ids = measure_locs_ids | w_measure_locs_ids

      @all_locs = all_locs_ids ? Location.where(id: all_locs_ids) : nil
    end
  end

  def build_locations_filters_hash
    filters = {}
    filters[:brand_ids] = selected_brands.map(&:id) unless selected_brands&.empty?
    filters[:channels] = selected_channels unless selected_channels&.empty?
    filters[:commune_ids] = selected_communes.map(&:id) unless selected_communes&.empty?
    filters[:region_ids] = selected_regions.map(&:id) unless selected_regions&.empty?
    filters
  end
end
