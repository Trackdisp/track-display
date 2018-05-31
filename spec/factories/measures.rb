FactoryBot.define do
  factory :measure do
    device
    campaign
    location
    measured_at "2018-05-10 15:53:32"
    people_count 1
    views_over_5 1
    views_over_15 1
    views_over_30 1
    male_count 1
    female_count 1
    avg_age 1
    happy_count 1
  end
end
