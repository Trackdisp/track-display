FactoryBot.define do
  factory :campaign do
    name "MyString"
    start_date "2018-05-17"
    end_date "2018-05-17"
    association :company
  end
end
