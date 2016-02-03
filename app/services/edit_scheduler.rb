class EditScheduler
  include Service
  include Virtus.model

  attribute :edit

  def call
    # create a new recording session job.  ignore server overload for the time being.
    RecordingSessionJob.perform_later(edit: edit)
  end
end
