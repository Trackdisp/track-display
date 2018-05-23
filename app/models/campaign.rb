class Campaign < ApplicationRecord
  belongs_to :company
  has_many :devices, dependent: :destroy
  has_many :measures, through: :devices, dependent: :destroy

  validates_presence_of :name

  delegate :name, to: :company, prefix: true, allow_nil: true
end

# == Schema Information
#
# Table name: campaigns
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  start_date :date
#  end_date   :date
#  company_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_campaigns_on_company_id  (company_id)
#
