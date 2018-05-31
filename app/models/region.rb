class Region < ApplicationRecord
  has_many :communes

  validates_presence_of :name
end

# == Schema Information
#
# Table name: regions
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
