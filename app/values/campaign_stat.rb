class CampaignStat
  include ActiveModel::SerializerSupport
  attr_accessor :campaign, :contacts_data, :contacts_sum, :female_data, :female_sum,
    :total_data, :total_sum, :effectiveness, :units_rotated_data, :units_rotated_sum,
    :total_male, :total_female, :total_happiness, :total_avg_age

  def initialize(opts = {})
    @campaign = opts[:campaign]
    init_contacts_stats(opts[:contacts])
    init_total_stats(opts[:total])
    init_units_stats(opts[:units_rotated])

    calculate_effectiveness
  end

  def init_contacts_stats(opts = {})
    @contacts_data = opts[:data]
    @contacts_sum = opts[:sum]
  end

  def init_total_stats(opts = {})
    @total_avg_age = opts[:avg_age]
    @female_data = opts[:female_data]
    @total_female = opts[:female]
    @total_male = opts[:male]
    @total_data = opts[:data]
    @total_sum = opts[:sum]

    @total_happiness = ((opts[:happiness] || 0) * 100).round
  end

  def init_units_stats(opts = {})
    @units_rotated_data = opts[:data]
    @units_rotated_sum = opts[:sum]
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
