class Location < ApplicationRecord
  include PowerTypes::Observable
  extend Enumerize
  belongs_to :brand, optional: true
  belongs_to :commune
  has_many :devices
  has_many :measures
  has_many :weight_measures

  validates_presence_of :name, :street, :number

  delegate :name, to: :brand, prefix: true, allow_nil: true
  delegate :region_id, to: :commune

  CHANNEL_TYPES = %i(traditional supermarket local_consumption)
  enumerize :channel, in: CHANNEL_TYPES

  def self.filtered(filters = {})
    q = all
    q = q.where(brand_id: filters[:brand_id]) if filters.has_key? :brand_id
    q = q.where(commune_id: filters[:commune_id]) if filters.has_key? :commune_id
    q = q.where(channel: filters[:channel]) if filters.has_key? :channel
    if filters.has_key? :region_id
      q = q.where(commune_id: Commune.where(region_id: filters[:region_id]).pluck(:id))
    end
    q
  end
end

# == Schema Information
#
# Table name: locations
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  channel    :string
#  street     :string
#  number     :integer
#  commune_id :bigint(8)
#  brand_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_brand_id    (brand_id)
#  index_locations_on_commune_id  (commune_id)
#
