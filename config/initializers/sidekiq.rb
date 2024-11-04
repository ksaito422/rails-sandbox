require "sidekiq/web"

REDIS_URL = "redis://localhost:6379/0".freeze
redis_url = { url: REDIS_URL }

Sidekiq.configure_server do |config|
  config.redis = redis_url
end

Sidekiq.configure_client do |config|
  config.redis = redis_url
end
