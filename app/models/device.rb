class Device < ApplicationRecord
  include PowerTypes::Observable

  belongs_to :campaign, optional: true
  belongs_to :location, optional: true
  has_many :measures, dependent: :destroy

  validates :serial, presence: true

  delegate :name, to: :campaign, prefix: true, allow_nil: true
  delegate :company_name, to: :campaign, prefix: false, allow_nil: true
end

# == Schema Information
#
# Table name: devices
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  serial      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  campaign_id :bigint(8)
#  location_id :bigint(8)
#
# Indexes
#
#  index_devices_on_campaign_id  (campaign_id)
#  index_devices_on_location_id  (location_id)
#
