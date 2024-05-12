FactoryBot.define do
  factory :author do
    name { "荒川 弘" }
  end

  trait :with_books do
    after(:create) do |author|
      create_list(:book, 3, author: author)
    end
  end
end
