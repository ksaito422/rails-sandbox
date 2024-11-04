class SampleJob
  include Sidekiq::Job

  def perform(name, count)
    sleep 3.minutes
    puts("Doing hard work for #{name} with #{count}")
  end
end
