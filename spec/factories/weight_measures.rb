FactoryBot.define do
  factory :weight_measure do
    association :device
    measured_at "2018-06-21 11:07:01"
    item_weight 10
    shelf_weight 89
    current_weight 550
    previous_weight 540
  end
end
