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

  def draft_videos
    # NOTE: The video drafter runs frame series for each activites for the
    # entire during between start_at and end_at.... this algorithm is TERRIBLE
    # VideoDrafter.call(start_at: activity_start_at,
    #                   end_at: activity_end_at,
    #                   activities: user.activities)
  end

  def draft_photos
    # PhotoDrafter.call(start_at: activity_start_at,
    #                   end_at: activity_end_at,
    #                   activities: user.activities)
  end

  def video_start_at
    first_video = VideoUpload.oldest_by_video_start_at&.first&.video
    @video_start_at ||= (first_video&.start_at || now).ago(4.hours)
  end

  def video_end_at
    last_video = VideoUpload.newest_by_video_end_at&.first&.video
    @video_end_at ||= (last_video&.end_at || now).since(4.hours)
  end

  def activity_start_at
    first_activity = user.activities.order(strava_start_at: :asc).first
    @activity_start_at ||= first_activity&.strava_start_at || now
  end

  def activity_end_at
    last_activity = user.activities.order(end_at: :desc).first
    @activity_end_at ||= last_activity&.end_at || now
  end

  def now
    @now ||= Time.zone.now
  end
end
