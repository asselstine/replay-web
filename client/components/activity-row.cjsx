StravaBadge = require('./strava-badge')
moment = require('moment')
ActivityRowSegmentEffort = require('./activity-row-segment-effort')

module.exports = React.createClass
  displayName: 'ActivityRow'

  propTypes:
    activity: React.PropTypes.object.isRequired

  render: ->
    if @props.activity.strava_activity_id
      viewOnStrava =
        <small>
          <a href={'https://www.strava.com/activities/' + @props.activity.strava_activity_id}
             className='strava'
             target='_blank'>
            View on Strava
          </a>
        </small>

    <div className='activity-row'>
      <div className='row'>
        <div className='col-sm-8'>
          <h1 className='inline-block'>
            <StravaBadge className='activity-row__strava-badge'/>
            {@props.activity.strava_name}
          </h1>
          {viewOnStrava}
        </div>
        <h3 className='col-sm-4 text-right-sm text-bottom'>
          {moment(@props.activity.strava_start_at).fromNow()}
        </h3>
      </div>
      <div className='activity-row__segment-efforts'>
        {@props.activity.segment_efforts.map (segmentEffort) =>
          <ActivityRowSegmentEffort segmentEffort={segmentEffort} key={segmentEffort.id}/>
        }
      </div>
    </div>
