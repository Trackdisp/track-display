class Device < ApplicationRecord
  belongs_to :company, optional: true
  has_many :measures, dependent: :destroy

  validates :serial, presence: true
end

# == Schema Information
#
# Table name: devices
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  serial     :string
#  company_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_devices_on_company_id  (company_id)
#
