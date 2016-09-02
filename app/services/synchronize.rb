class Synchronize
  include Service
  include Virtus.model

  attribute :user, User

  def call
    sync_strava if user.strava_account
    draft_videos
    draft_photos
  end

  private

  def sync_strava
    StravaActivitySync.call(user: user,
                            start_at: video_start_at,
                            end_at: video_end_at)
  end

  def draft
    user.activities.each do |activity|
      VideoDrafter.call(start_at: activity.start_at,
                        end_at: activity.end_at,
                        activities: [activity])
      PhotoDrafter.call(start_at: activity.start_at,
                        end_at: activity.end_at,
                        activities: [activity])
    end
  end

  def video_start_at
    first_video = VideoUpload.oldest_by_video_start_at&.first&.video
    @video_start_at ||= (first_video&.start_at || now).ago(4.hours)
  end

  def video_end_at
    last_video = VideoUpload.newest_by_video_end_at&.first&.video
    @video_end_at ||= (last_video&.end_at || now).since(4.hours)
  end

  def now
    @now ||= Time.zone.now
  end
end
