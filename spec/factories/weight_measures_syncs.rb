FactoryBot.define do
  factory :weight_measures_sync do
    state :created
    from_date 1.hour.ago
    to_date Time.current
    start_time nil
    end_time nil
  end
end
