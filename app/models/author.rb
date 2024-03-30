class Author < ApplicationRecord
  # has_many :books
  has_one :book
  # has_many :books, inverse_of: :writer
end
