class CampaignsController < BaseController
  def index; end

  def show
    measures = Measure.by_campaign(campaign.id)
    @graphs_data = {
      total_people: measures.group_by_week(:measured_at).sum(:people_count),
      views_over_5: measures.group_by_week(:measured_at).sum(:views_over_5)
    }
    @total_views_count = measures.sum(:views_over_5)
    @total_people_count = measures.sum(:people_count)
    @effectiveness = if @total_people_count
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
