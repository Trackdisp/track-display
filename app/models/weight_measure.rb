class WeightMeasure < ApplicationRecord
  include Elastic::MeasureIndex
  include PowerTypes::Observable

  belongs_to :device
  belongs_to :location, optional: true
  belongs_to :campaign, optional: true

  before_create :set_campaign_and_location
  before_create :set_items_count

  scope :by_company, ->(company_id) do
    joins(:campaign).where(campaigns: { company_id: company_id })
  end
  scope :by_campaign, ->(campaign_id) { where(campaign_id: campaign_id) }
  scope :by_location, ->(location_id) { where(location_id: location_id) }

  validates(
    :item_weight,
    :shelf_weight,
    :current_weight,
    :previous_weight,
    numericality: {
      greater_than_or_equal_to: 0
    }
  )

  validates_presence_of :measured_at

  delegate :name, :serial, to: :device, allow_nil: true, prefix: true
  delegate :brand_name, :campaign_name, :company_name, :location_name,
    to: :device, allow_nil: true, prefix: false

  def set_campaign_and_location
    self.campaign = device.campaign
    self.location = device.location
  end

  def set_items_count
    self.items_count = (previous_weight - current_weight) / item_weight
  end
end

# == Schema Information
#
# Table name: weight_measures
#
#  id              :bigint(8)        not null, primary key
#  device_id       :bigint(8)
#  location_id     :bigint(8)
#  campaign_id     :bigint(8)
#  measured_at     :datetime
#  item_weight     :integer
#  shelf_weight    :integer
#  current_weight  :integer
#  previous_weight :integer
#  items_count     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_weight_measures_on_campaign_id  (campaign_id)
#  index_weight_measures_on_device_id    (device_id)
#  index_weight_measures_on_location_id  (location_id)
#