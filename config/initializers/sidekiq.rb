require "sidekiq/web"

REDIS_URL = "redis://localhost:6379/0".freeze
redis_url = { url: REDIS_URL }

Sidekiq.configure_server do |config|
  config.redis = redis_url
  config.death_handlers << ->(job, ex) do
    puts "Uh oh, #{job['class']} #{job["jid"]} just died with error #{ex.message}."
  end
  config.logger = Sidekiq::Logger.new($stdout)
  config.logger.level = Logger::INFO
  config.logger.formatter = Sidekiq::Logger::Formatters::JSON.new
end

Sidekiq.configure_client do |config|
  config.redis = redis_url
end
