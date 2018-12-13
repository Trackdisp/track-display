class Api::V1::CampaignsController < Api::V1::BaseController
  include CampaignFiltered

  def dependant_filters_options
    render json: { "locations[]": location_options, "communes[]": commune_options  }, status: :ok
  end
end
