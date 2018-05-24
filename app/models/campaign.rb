class Campaign < ApplicationRecord
  extend FriendlyId
  belongs_to :company
  has_many :devices

  validates_presence_of :name, :start_date, :end_date

  friendly_id :name, use: :slugged

  def date_range
    (start_date..end_date)
  end

  def total_views
    Measure.by_campaign(id).sum(:views_over_5)
  end

  def total_people
    Measure.by_campaign(id).sum(:people_count)
  end
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
#  slug       :string
#
# Indexes
#
#  index_campaigns_on_company_id  (company_id)
#
