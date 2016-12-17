_ = require('lodash')
ActivityPlayer = require('./activity-player')
VideoPlayer = require('./video-player')
EventEmitter = require('wolfy87-eventemitter')

module.exports = React.createClass
  displayName: 'VideoDraft'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  getInitialState: ->
    eventEmitter: new EventEmitter()

  render: ->
    <div className='video-draft'>
      <h3>{@props.videoDraft.name}</h3>
      <div className='data-video-player'>
        <VideoPlayer video={@props.videoDraft.video}
                     videoEventEmitter={@state.eventEmitter}/>
        <ActivityPlayer activity={@props.videoDraft.activity}
                        videoEventEmitter={@state.eventEmitter}/>
      </div>
    </div>
