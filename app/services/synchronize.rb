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
    start_at = VideoUpload.oldest_by_video_start_at.first.video.start_at
    end_at = VideoUpload.newest_by_video_end_at.first.video.end_at
    StravaActivitySync.call(user: user,
                            start_at: start_at,
                            end_at: end_at)
  end

  def draft_videos
    VideoDrafter.call(start_at: start_at,
                      end_at: now,
                      activities: user.activities)
  end

  def draft_photos
    PhotoDrafter.call(start_at: start_at,
                      end_at: now,
                      activities: user.activities)
  end

  def start_at
    first_activity = user.activities.order(strava_start_at: :asc).first
    @start_at ||= first_activity&.strava_start_at || now
  end

  def now
    @now ||= Time.zone.now
  end
end
