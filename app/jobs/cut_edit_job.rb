class CutEditJob < ActiveJob::Base
  queue_as :default

  def perform(edit: video_edit)
    if Rails.env.test?
      Cutter.new(video_edit: edit).call
    else
      RemoteCutter.new(video_edit: edit).call
    end
  end
end
