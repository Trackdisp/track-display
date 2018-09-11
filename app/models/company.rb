class Company < ApplicationRecord
  include PowerTypes::Observable

  has_many :users, dependent: :destroy
  has_many :campaigns, dependent: :destroy
  has_many :devices, through: :campaigns
  has_many :measures, through: :campaigns, dependent: :destroy
  has_many :weight_measures, through: :campaigns, dependent: :destroy
  has_one_attached :logo

  validates :name, presence: true
end

# == Schema Information
#
# Table name: companies
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
