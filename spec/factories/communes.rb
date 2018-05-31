FactoryBot.define do
  factory :commune do
    name 'Commune Test'
    association :region
  end
end
