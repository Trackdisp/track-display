FactoryBot.define do
  factory :location do
    name 'LocationTest'
    channel :traditional
    region "MyString"
    commune "MyString"
    street "MyString"
    number 1
  end
end
