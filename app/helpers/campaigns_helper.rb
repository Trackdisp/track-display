module CampaignsHelper
  def campaign_graph(graphs_data)
    line_chart(
      [
        { name: 'Total People', data: graphs_data[:total] },
        { name: 'Views Over 5', data: graphs_data[:contacts] }
      ],
      legend: false,
      colors: %w(#11B0FC #00D976),
      library: { chart: { zoomType: 'x' } }
    )
  end

  def campaign_date_range(campaign)
    "#{I18n.localize(campaign.start_date, format: :long).upcase} -
      #{I18n.localize(campaign.end_date, format: :long).upcase}"
  end
end
