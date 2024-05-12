FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "鋼の錬金術師#{n}" }
  end
end
