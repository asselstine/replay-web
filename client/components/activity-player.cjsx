format = require('../util/format')

module.exports = React.createClass
  displayName: 'ActivityPlayer'

  propTypes:
    activity: React.PropTypes.object.isRequired
    videoEventEmitter: React.PropTypes.object.isRequired

  getInitialState: ->
    currentTime: 0

  componentDidMount: ->
    @props.videoEventEmitter.on('videoRafTick', @videoRafTick)

  componentWillUnmount: ->
    @props.videoEventEmitter.off('videoRafTick', @videoRafTick)

  videoRafTick: (timestamp) ->
    @setState
      currentTime: timestamp

  render: ->
    if @state.currentTime
      currentTime = format.elapsed(@state.currentTime*1000)

    <div className='activity-player'>
      <div className='activity-player__activity-box'>
        <div className='activity-player__activity-name'>
          {@props.activity.strava_name}
        </div>
        <div className='activity-player__activity-current-time'>
          {currentTime}
        </div>
      </div>
    </div>
