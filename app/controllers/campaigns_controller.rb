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
      brand: brand,
      channel: channel
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
    locs_filtered_by_brand = all_locs.select { |l| l.brand_id == @brand&.id }
    selected_locs = @brand ? locs_filtered_by_brand : all_locs
    @locations = @channel ? selected_locs.select { |l| l.channel == @channel } : selected_locs
    @brands = Brand.find(all_locs.pluck(:brand_id).uniq)

    @channels = all_locs.reduce(Set.new) do |arr, loc|
      arr.add(name: t("enumerize.channel.#{loc.channel}"), id: loc.channel)
    end
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

    all_locs_ids ? Location.find(all_locs_ids) : nil
  end

  def location
    @location ||= Location.find_by(id: params[:location].to_i) if params[:location].present?
  end

  def brand
    @brand ||= Brand.find_by(id: params[:brand].to_i) if params[:brand].present?
  end

  def channel
    @channel ||= params[:channel]
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
