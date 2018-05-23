module HomeHelper
  def campaign_graph(graphs_data)
    line_chart(
      [
        { name: 'Total People', data: graphs_data[:total_people] },
        { name: 'Views Over 5', data: graphs_data[:views_over_5] }
      ],
      legend: false, colors: %w(#11B0FC #00D976), library: { chart: { zoomType: 'x' } }
    )
  end
end
