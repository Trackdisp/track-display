FactoryBot.define do
  factory :measure do
    device
    campaign
    location
    measured_at "2018-05-10 15:53:32"
    avg_age 1
    w_id 'dsfsafs12'
    presence_duration 8
    contact_duration 5
    happiness 0.3
    gender :female
  end
end
