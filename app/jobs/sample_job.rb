class SampleJob
  include Sidekiq::Job
  sidekiq_options queue: :default, retry: 3, tags: [ "alpha", "🥇" ]

  def perform(name, count)
    sleep 3.minutes
    logger.info("Performing job for #{name} with count #{count}")
  end
end
