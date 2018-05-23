class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :campaigns, dependent: :destroy
  has_many :devices, through: :campaigns, dependent: :destroy
  has_many :measures, through: :devices, dependent: :destroy

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
