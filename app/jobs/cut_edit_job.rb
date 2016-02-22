class CutEditJob < ActiveJob::Base
  queue_as :default

  def perform(video_edit:)
    if Rails.env.test?
      Cutter.new(video_edit: video_edit).call
    else
      RemoteCutter.new(video_edit: video_edit).call
    end
  end
end
