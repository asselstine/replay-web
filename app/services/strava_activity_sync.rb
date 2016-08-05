# rubocop:disable Metrics/ClassLength
class StravaActivitySync
  PAGE_SIZE = 10

  include Service
  include Virtus.model

  DATE_FORMAT = '%Y-%m-%d %H:%M:%S.%3N'.freeze

  attribute :user, User
  attribute :start_at
  attribute :end_at

  def call
    @page = 0
    debug('Connecting to Strava...')
    return if client.nil?
    debug('Starting Data sync...')
    ActiveRecord::Base.transaction do
      loop do
        activities = client.list_athlete_activities(params)
        find_or_create_activities(activities)
        break if activities.count < PAGE_SIZE
      end
    end
  end

  protected

  def find_or_create_activities(activities)
    debug("Found #{activities.length} activites")
    activities.each do |strava_activity|
      find_or_create_activity(strava_activity)
    end
  end

  def params
    result = {}
    result[:after] = (start_at.to_i - 1) if start_at
    result[:before] = (end_at.to_i + 1) if end_at
    result[:page] = @page += 1
    result[:page_size] = PAGE_SIZE
    result
  end

  def find_or_create_activity(strava_activity)
    debug(<<-STRING
      Checking strava activity #{strava_activity['id']} \
      with name #{strava_activity['name']}
    STRING
         )
    activity = @user.activities.where(
      strava_activity_id: strava_activity['id']
    ).first
    unless activity
      activity = create_activity(strava_activity)
      create_segment_efforts(activity)
    end
    activity
  end

  # rubocop:disable Metrics/AbcSize
  def create_activity(strava_activity)
    streams = client.retrieve_activity_streams(strava_activity['id'],
                                               'latlng,time,velocity_smooth')
    start_at = DateTime.parse(strava_activity['start_date'])
    activity = @user.activities.create(
      strava_activity_id: strava_activity['id'],
      strava_name: strava_activity['name'],
      strava_start_at: start_at,
      timestamps: streams[1]['data'],
      latitudes: latitudes(streams[0]['data']),
      longitudes: longitudes(streams[0]['data']),
      velocities: streams[2]['data']
    )
    debug("Created new activity: #{activity}")
    activity
  end

  def create_segment_efforts(activity)
    strava_activity = client.retrieve_an_activity(activity.strava_activity_id,
                                                  include_all_efforts: true)
    strava_activity['segment_efforts'].map do |strava_segment_effort|
      find_or_create_segment_effort(activity, strava_segment_effort)
    end
  end

  def find_or_create_segment_effort(activity, strava_segment_effort)
    effort = SegmentEffort.where(
      strava_segment_effort_id: strava_segment_effort['id']
    ).first
    unless effort
      effort = create_segment_effort(activity, strava_segment_effort)
    end
    effort
  end

  # rubocop:disable Metrics/MethodLength
  def create_segment_effort(activity, strava_segment_effort)
    segment = find_or_create_segment(
      strava_segment_effort['segment']
    )
    end_at = DateTime.parse(strava_segment_effort['start_date']) +
             strava_segment_effort['elapsed_time'].seconds
    SegmentEffort.create(
      strava_segment_effort_id: strava_segment_effort['id'],
      name: strava_segment_effort['name'],
      start_at: strava_segment_effort['start_date'],
      end_at: end_at,
      elapsed_time: strava_segment_effort['elapsed_time'],
      moving_time: strava_segment_effort['moving_time'],
      start_index: strava_segment_effort['start_index'],
      end_index: strava_segment_effort['end_index'],
      kom_rank: strava_segment_effort['kom_rank'],
      pr_rank: strava_segment_effort['pr_rank'],
      activity: activity,
      segment: segment
    )
  end

  def find_or_create_segment(strava_segment)
    Segment.where(strava_segment_id: strava_segment['id'])
           .first_or_create(
             strava_segment_id: strava_segment['id'],
             name: strava_segment['name'],
             activity_type: strava_segment['activity_type'],
             distance: strava_segment['distance'],
             average_grade: strava_segment['average_grade'],
             maximum_grade: strava_segment['maximum_grade'],
             elevation_high: strava_segment['elevation_high'],
             elevation_low: strava_segment['elevation_low'],
             city: strava_segment['city'],
             state: strava_segment['state'],
             country: strava_segment['country'],
             is_private: strava_segment['private']
           )
  end

  def latitudes(latlng_stream)
    latlng_stream.map { |latlng| latlng[0] }
  end

  def longitudes(latlng_stream)
    latlng_stream.map { |latlng| latlng[1] }
  end

  def client
    user.strava_account.client
  end

  def debug(str)
    Rails.logger.debug("StravaActivitySync(user: #{user.id}): #{str}")
  end
end
