FactoryBot.define do
  factory :device do
    association :company
    association :campaign
    name { Faker::DragonBall.character }
    serial { SecureRandom.hex(10) }
  end
end
