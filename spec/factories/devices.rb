FactoryBot.define do
  factory :device do
    sequence :name do |n|
      "Device#{n}"
    end
    sequence :serial do |n|
      "serial#{n}"
    end
    association :company
  end
end
