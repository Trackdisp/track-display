class Brand < ApplicationRecord
  extend Enumerize
  has_many :locations
  validates_presence_of :name, :channel

  CHANNEL_TYPES = %i(traditional supermaket local_consumption)
  enumerize :channel, in: CHANNEL_TYPES, default: CHANNEL_TYPES.first
end

# == Schema Information
#
# Table name: brands
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  channel    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#