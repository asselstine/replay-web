VideoJsPlayer = require('./video-js-player')
ActivityPlayer = require('./activity-player')
EventEmitter = require('wolfy87-eventemitter')

module.exports = React.createClass
  displayName: 'DataVideoPlayer'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  getInitialState: ->
    eventEmitter: new EventEmitter()

  render: ->
    <div className='data-video-player'>
      <VideoJsPlayer video={@props.videoDraft.video}
                     videoEventEmitter={@state.eventEmitter}/>
      <ActivityPlayer activity={@props.videoDraft.activity}
                      segmentEfforts={@props.videoDraft.segment_efforts}
                      videoEventEmitter={@state.eventEmitter}/>
    </div>
