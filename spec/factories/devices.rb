FactoryBot.define do
  factory :device do
    association :campaign
    association :location
    name { Faker::DragonBall.character }
    serial { SecureRandom.hex(10) }
  end
end
