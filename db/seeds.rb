# Performance Testing Seed Data
# Run with: rails db:seed
# Reset with: rails db:reset (drops, creates, migrates, seeds)

puts "Creating performance testing data..."

# Clear existing data
PostTag.destroy_all
Comment.destroy_all
Post.destroy_all
Tag.destroy_all
Category.destroy_all
User.destroy_all

# Reset sequences
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('categories')
ActiveRecord::Base.connection.reset_pk_sequence!('posts')
ActiveRecord::Base.connection.reset_pk_sequence!('comments')
ActiveRecord::Base.connection.reset_pk_sequence!('tags')
ActiveRecord::Base.connection.reset_pk_sequence!('post_tags')

puts "Creating users..."
users = []
100000.times do |i|
  users << {
    name: "User #{i + 1}",
    email: "user#{i + 1}@example.com",
    age: rand(18..80),
    created_at: rand(2.years.ago..Time.current),
    updated_at: Time.current
  }
end
User.insert_all(users)
user_ids = User.pluck(:id)
puts "Created #{User.count} users"

# Create Categories (50 categories)
puts "Creating categories..."
categories = []
50.times do |i|
  categories << {
    name: "Category #{i + 1}",
    description: "Description for category #{i + 1}",
    created_at: Time.current,
    updated_at: Time.current
  }
end
Category.insert_all(categories)
category_ids = Category.pluck(:id)
puts "Created #{Category.count} categories"

# Create Tags (200 tags)
puts "Creating tags..."
tags = []
colors = ['red', 'blue', 'green', 'yellow', 'purple', 'orange', 'pink', 'brown']
200.times do |i|
  tags << {
    name: "Tag #{i + 1}",
    color: colors.sample,
    created_at: Time.current,
    updated_at: Time.current
  }
end
Tag.insert_all(tags)
tag_ids = Tag.pluck(:id)
puts "Created #{Tag.count} tags"

# Create Posts (50,000 posts for heavy query testing)
puts "Creating posts..."
posts = []
50000.times do |i|
  published = rand < 0.8 # 80% published
  created_time = rand(1.year.ago..Time.current)
  
  posts << {
    title: "Post Title #{i + 1}",
    content: "This is the content for post #{i + 1}. " * rand(5..50), # Variable content length
    user_id: user_ids.sample,
    category_id: category_ids.sample,
    published: published,
    published_at: published ? created_time : nil,
    created_at: created_time,
    updated_at: created_time
  }
  
  # Batch insert every 1000 records for performance
  if posts.size == 1000
    Post.insert_all(posts)
    posts = []
    print "."
  end
end
Post.insert_all(posts) if posts.any?
post_ids = Post.pluck(:id)
puts "\nCreated #{Post.count} posts"

# Create Comments (200,000 comments for N+1 testing)
puts "Creating comments..."
comments = []
200000.times do |i|
  comments << {
    content: "This is comment #{i + 1}",
    post_id: post_ids.sample,
    user_id: user_ids.sample,
    created_at: rand(6.months.ago..Time.current),
    updated_at: Time.current
  }
  
  # Batch insert every 2000 records
  if comments.size == 2000
    Comment.insert_all(comments)
    comments = []
    print "."
  end
end
Comment.insert_all(comments) if comments.any?
puts "\nCreated #{Comment.count} comments"

# Create PostTags (many-to-many relationships, 150,000 records)
puts "Creating post-tag relationships..."
post_tags = []
used_combinations = Set.new

150000.times do |i|
  loop do
    post_id = post_ids.sample
    tag_id = tag_ids.sample
    combination = [post_id, tag_id]
    
    unless used_combinations.include?(combination)
      used_combinations.add(combination)
      post_tags << {
        post_id: post_id,
        tag_id: tag_id,
        created_at: Time.current,
        updated_at: Time.current
      }
      break
    end
  end
  
  # Batch insert every 2000 records
  if post_tags.size == 2000
    PostTag.insert_all(post_tags)
    post_tags = []
    print "."
  end
end
PostTag.insert_all(post_tags) if post_tags.any?
puts "\nCreated #{PostTag.count} post-tag relationships"

puts "\n=== Seed Data Summary ==="
puts "Users: #{User.count}"
puts "Categories: #{Category.count}"
puts "Posts: #{Post.count}"
puts "Comments: #{Comment.count}"
puts "Tags: #{Tag.count}"
puts "PostTags: #{PostTag.count}"
puts "\nData creation completed! Ready for performance testing."
puts "Try: User.includes(:posts).limit(10) vs User.limit(10).each { |u| u.posts.count }"
