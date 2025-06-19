class PostCreatorJob
  include Sidekiq::IterableJob

  def build_enumerator(start_at, count, **kwargs)
    @start_at = start_at
    @count = count
    logger.info("Creating posts for #{start_at}")
    array_enumerator((start_at...(start_at + count)).to_a, **kwargs)
  end

  def each_iteration(pid, *_unused_args)
    sleep 5.minutes
    Post.create(title: "Post #{pid}", body: "This is post #{pid}")
  end

  def on_start
    logger.info("Starting to create posts")
  end

  def on_complete
    logger.info("Finished creating posts")
  end
end
