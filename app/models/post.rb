class Post < ApplicationRecord
  scope :oldest, -> { order(created_at: :asc) }
  scope :recent, -> { order(created_at: :desc) }
end
