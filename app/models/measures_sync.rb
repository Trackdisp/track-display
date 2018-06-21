class MeasuresSync < ApplicationRecord
  extend Enumerize
  include AASM

  has_many :measures

  scope :completed, -> { where(state: :completed) }
  scope :by_to_date, -> { order(to_date: :desc) }

  validates_presence_of :state, :from_date, :to_date

  SYNC_STATE = %i(created executing completed failed)
  enumerize :state, in: SYNC_STATE, default: :created

  aasm :measures_sync, column: :state do
    state :created, initial: true
    SYNC_STATE.without(:created).each do |state_name|
      state state_name
    end

    event :execute, after: Proc.new { update(start_time: DateTime.current) } do
      transitions from: :created, to: :executing
    end

    event :fail, after: Proc.new { update(end_time: DateTime.current) } do
      transitions from: :executing, to: :failed
    end

    event :complete, after: Proc.new { update(end_time: DateTime.current) } do
      transitions from: :executing, to: :completed
    end
  end
end

# == Schema Information
#
# Table name: measures_syncs
#
#  id         :bigint(8)        not null, primary key
#  state      :string
#  from_date  :datetime
#  to_date    :datetime
#  start_time :datetime
#  end_time   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
