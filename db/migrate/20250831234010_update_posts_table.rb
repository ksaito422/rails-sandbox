class UpdatePostsTable < ActiveRecord::Migration[8.0]
  def change
    change_table :posts do |t|
      t.rename :body, :content
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.boolean :published, default: false
      t.datetime :published_at
    end
  end
end
