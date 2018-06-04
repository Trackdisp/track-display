class Measure < ApplicationRecord
  include Elastic::MeasureIndex
  include PowerTypes::Observable

  belongs_to :device
  belongs_to :campaign, optional: true
  belongs_to :location, optional: true

  before_create :set_campaign_and_location

  scope :by_company, ->(company_id) do
    joins(:campaign).where(campaigns: { company_id: company_id })
  end
  scope :by_campaign, ->(campaign_id) { where(campaign_id: campaign_id) }
  scope :by_location, ->(location_id) { where(location_id: location_id) }

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
  delegate :brand_name, :campaign_name, :company_name, :location_name,
    to: :device, allow_nil: true, prefix: false

  def set_campaign_and_location
    self.campaign = device.campaign
    self.location = device.location
  end
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
#  campaign_id   :bigint(8)
#  location_id   :bigint(8)
#
# Indexes
#
#  index_measures_on_campaign_id  (campaign_id)
#  index_measures_on_device_id    (device_id)
#  index_measures_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (device_id => devices.id)
#
