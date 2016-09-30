class VideoUploadDrafterJob < ActiveJob::Base
  queue_as :default

  def perform(video_upload_id)
    video_upload = VideoUpload.find(video_upload_id)
    sync_strava(video_upload)
    draft_videos(video_upload)
  end

  def sync_strava(video_upload)
    StravaActivitySync.call(user: video_upload.user,
                            start_at: video_upload.video.start_at.ago(1.hour),
                            end_at: video_upload.video.end_at.since(1.hour))
  end

  def draft_videos(video_upload)
    VideoDrafter.call(start_at: video_upload.video.start_at,
                      end_at: video_upload.video.end_at,
                      setups: video_upload.setups)
  end
end
