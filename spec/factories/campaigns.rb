FactoryBot.define do
  factory :campaign do
    company
    name { Faker::GameOfThrones.character + " Campaign" }
    start_date "2018-05-17"
    end_date "2018-05-17"
  end
end
