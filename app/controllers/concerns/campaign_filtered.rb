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
end
