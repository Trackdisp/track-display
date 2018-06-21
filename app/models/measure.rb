class Measure < ApplicationRecord
  include Elastic::MeasureIndex
  include PowerTypes::Observable
  extend Enumerize

  belongs_to :device
  belongs_to :campaign, optional: true
  belongs_to :location, optional: true
  belongs_to :measures_sync, optional: true

  before_create :set_campaign_and_location

  scope :by_company, ->(company_id) do
    joins(:campaign).where(campaigns: { company_id: company_id })
  end
  scope :by_campaign, ->(campaign_id) { where(campaign_id: campaign_id) }
  scope :by_location, ->(location_id) { where(location_id: location_id) }
  scope :has_contact, -> { where('contact_duration > ?', ENV.fetch('CONTACT_TIME', 5)) }

  validates(
    :avg_age,
    :presence_duration,
    :contact_duration,
    numericality: {
      greater_than_or_equal_to: 0
    }
  )

  validates_numericality_of :happiness, greater_than_or_equal_to: 0, less_than_or_equal_to: 1

  GENDER_TYPES = %i(undefined male female)
  enumerize :gender, in: GENDER_TYPES, default: :undefined

  validates_presence_of :measured_at, :w_id, :gender

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
#  id                :bigint(8)        not null, primary key
#  device_id         :bigint(8)
#  measured_at       :datetime
#  avg_age           :decimal(4, 1)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_id       :bigint(8)
#  location_id       :bigint(8)
#  w_id              :string
#  presence_duration :decimal(4, 1)
#  contact_duration  :decimal(4, 1)
#  happiness         :decimal(4, 3)
#  gender            :string
#  measures_sync_id  :bigint(8)
#
# Indexes
#
#  index_measures_on_campaign_id       (campaign_id)
#  index_measures_on_device_id         (device_id)
#  index_measures_on_location_id       (location_id)
#  index_measures_on_measures_sync_id  (measures_sync_id)
#
# Foreign Keys
#
#  fk_rails_...  (device_id => devices.id)
#  fk_rails_...  (measures_sync_id => measures_syncs.id)
#
