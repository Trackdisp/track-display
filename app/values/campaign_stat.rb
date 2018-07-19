class CampaignStat
  include ActiveModel::SerializerSupport
  attr_accessor :campaign, :contacts_data, :contacts_sum, :total_data, :total_sum, :effectiveness,
    :units_rotated_data, :units_rotated_sum

  def initialize(opts = {})
    @campaign = opts[:campaign]
    @contacts_data = opts[:contacts_data]
    @contacts_sum = @contacts_data.values.sum
    @total_data = opts[:total_data]
    @total_sum = @total_data.values.sum
    @units_rotated_data = opts[:units_rotated_data]
    @units_rotated_sum = opts[:units_rotated_sum]

    calculate_effectiveness
  end

  def calculate_effectiveness
    @effectiveness =
      if @total_sum != 0
        ((100 * @contacts_sum) / @total_sum.to_f).round
      else
        0
      end
  end
end
