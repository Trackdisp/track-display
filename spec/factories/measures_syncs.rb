FactoryBot.define do
  factory :measures_sync do
    state :created
    from_date 15.minutes.ago
    to_date Time.current
    start_time nil
    end_time nil
  end
end
