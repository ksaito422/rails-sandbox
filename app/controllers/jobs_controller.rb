class JobsController < ApplicationController
  def index
  end

  def run_sample_job
    name = params[:name] || "Default User"
    count = params[:count]&.to_i || 1

    SampleJob.perform_async(name, count)

    redirect_to jobs_path, notice: "SampleJobがキューに追加されました (名前: #{name}, カウント: #{count})"
  end
end
