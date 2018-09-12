class CampaignStat
  include ActiveModel::SerializerSupport
  attr_accessor :campaign, :contacts_data, :contacts_sum, :contacts_female_data,
    :contacts_male_data, :total_female_avg_age, :total_male_avg_age, :total_data,
    :total_sum, :effectiveness, :units_extracted_data, :units_extracted_sum,
    :total_male_sum, :total_female_sum, :total_happiness, :total_avg_age, :avg_age_data,
    :contacts_female_sum, :contacts_male_sum, :total_female_happiness, :total_male_happiness,
    :female_effectiveness, :male_effectiveness

  def initialize(opts = {})
    @campaign = opts[:campaign]
    init_contacts_stats(opts[:contacts])
    init_total_stats(opts[:total])
    init_units_stats(opts[:units_extracted])

    calculate_effectiveness
  end

  def init_contacts_stats(opts = {})
    @contacts_data = opts[:data]
    @contacts_sum = opts[:sum]
    @contacts_female_data = opts[:female_data]
    @contacts_male_data = opts[:male_data]
    @contacts_female_sum = opts[:female]
    @contacts_male_sum = opts[:male]
    @avg_age_data = opts[:avg_age_data]
  end

  def init_total_stats(opts = {})
    @total_avg_age = opts[:avg_age]
    @total_female_sum = opts[:female]
    @total_male_sum = opts[:male]
    @total_female_avg_age = opts[:female_avg_age]
    @total_male_avg_age = opts[:male_avg_age]
    @total_data = opts[:data]
    @total_sum = opts[:sum]
    @total_happiness = ((opts[:happiness] || 0) * 100).round
    @total_female_happiness = ((opts[:female_happiness] || 0) * 100).round
    @total_male_happiness = ((opts[:male_happiness] || 0) * 100).round
  end

  def init_units_stats(opts = {})
    @units_extracted_data = opts[:data]
    @units_extracted_sum = opts[:sum]
  end

  def calculate_effectiveness
    @effectiveness =
      @total_sum != 0 ? ((100 * @contacts_sum) / @total_sum.to_f).round : 0
    @female_effectiveness =
      @total_female_sum != 0 ? ((100 * @contacts_female_sum) / @total_female_sum.to_f).round : 0
    @male_effectiveness =
      @total_male_sum != 0 ? ((100 * @contacts_male_sum) / @total_male_sum.to_f).round : 0
  end
end
