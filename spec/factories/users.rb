FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password "password123"
    password_confirmation "password123"
    association :company
  end
end
