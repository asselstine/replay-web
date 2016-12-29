Around '@perform_jobs' do |_, block|
  @old_pej = ActiveJob::Base.queue_adapter.perform_enqueued_jobs
  @old_peatj = ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs
  ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
  ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true
  begin
    block.call
  ensure
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = @old_pej
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = @old_peatj
  end
end
