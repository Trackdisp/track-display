FactoryBot.define do
  factory :location do
    name 'LocationTest'
    channel :traditional
    association :region
    association :commune
    street 'Street Test'
    number 1
  end
end
