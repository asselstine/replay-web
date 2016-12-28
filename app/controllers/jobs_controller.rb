class JobsController < LoggedInController
  def index
    @jobs = current_user.jobs
  end

  def create
    @job = Job.new(job_params)
    status = @job.save ? :ok : :unprocessable_entity
    Jobs::Start.call(job: @job) if @job.persisted?
    render json: @job, status: status
  end

  def job_params
    params.require(:job)
          .permit(:video_id,
                  :rotation)
  end
end
