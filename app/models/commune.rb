class Commune < ApplicationRecord
  belongs_to :region

  validates_presence_of :name
end

# == Schema Information
#
# Table name: communes
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  region_id  :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_communes_on_region_id  (region_id)
#
