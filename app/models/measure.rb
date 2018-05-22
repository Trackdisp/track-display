class Measure < ApplicationRecord
  include Elastic::MeasureIndex

  belongs_to :device

  scope :by_company, ->(company_id) { joins(:device).where(devices: { company_id: company_id }) }
  scope :by_campaign, ->(campaign_id) do
    joins(:device).where(devices: { campaign_id: campaign_id })
  end

  validates(
    :people_count,
    :views_over_5,
    :views_over_15,
    :views_over_30,
    :male_count,
    :female_count,
    :avg_age,
    :happy_count,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      allow_nil: true
    }
  )

  validates :measured_at, presence: true

  delegate :name, :serial, to: :device, allow_nil: true, prefix: true
  delegate :company_name, to: :device, allow_nil: true, prefix: false
end

# == Schema Information
#
# Table name: measures
#
#  id            :bigint(8)        not null, primary key
#  device_id     :bigint(8)
#  measured_at   :datetime
#  people_count  :integer
#  views_over_5  :integer
#  views_over_15 :integer
#  views_over_30 :integer
#  male_count    :integer
#  female_count  :integer
#  avg_age       :integer
#  happy_count   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_measures_on_device_id  (device_id)
#
# Foreign Keys
#
#  fk_rails_...  (device_id => devices.id)
#
