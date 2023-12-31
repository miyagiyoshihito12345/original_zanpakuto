FactoryBot.define do
  factory :post do
    sequence(:shikai, "shikai_1")
    ability { 'Ability' }
    is_draft { false }
    association :user
  end
end
