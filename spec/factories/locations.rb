FactoryBot.define do
  factory :location do
    name 'LocationTest'
    channel :traditional
    association :commune
    association :brand
    street 'Street Test'
    number 1
  end
end
