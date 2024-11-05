class SampleJob
  include Sidekiq::Job
  sidekiq_options queue: :default, retry: 3, tags: [ "alpha", "🥇" ]

  def perform(name, count)
    sleep 3.minutes
    puts("Doing hard work for #{name} with #{count}")
  end
end
