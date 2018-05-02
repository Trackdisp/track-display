FactoryBot.define do
  factory :company do
    sequence :name do |n|
      "Company#{n}"
    end
  end
end
