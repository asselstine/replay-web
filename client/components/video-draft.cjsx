_ = require('lodash')
moment = require('moment')
ActivityPlayer = require('./activity-player')
VideoPlayer = require('./video-player')
EventEmitter = require('wolfy87-eventemitter')
SegmentEffortOverlay = require('./segment-effort-overlay')

module.exports = React.createClass
  displayName: 'VideoDraft'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  getInitialState: ->
    eventEmitter: new EventEmitter()
    currentTime: 0

  componentDidMount: ->
    efforts = @props.videoDraft.segment_efforts
    if efforts.length
      effort = efforts[0]
      @setState
        currentTime: @videoTime(effort.start_index)
        currentSegmentEffort: effort

  videoTime: (start_index) ->
    segmentStartSecond = @props.videoDraft.activity.timestamps_f[start_index]
    segmentStartAt = moment(@props.videoDraft.activity.start_at).add(segmentStartSecond, 'seconds')
    videoStartAt = moment(@props.videoDraft.video.start_at)
    segmentStartAt.diff(videoStartAt, 'seconds', true)

  render: ->
    if @state.currentSegmentEffort
      segmentEffortOverlay =
        <SegmentEffortOverlay activity={@props.videoDraft.activity}
                              segmentEffort={@state.currentSegmentEffort}
                              eventEmitter={@state.eventEmitter}/>

    <div className='video-draft'>
      <h3>{@props.videoDraft.name}</h3>
      <div className='data-video-player'>
        <VideoPlayer video={@props.videoDraft.video}
                     currentTime={@state.currentTime}
                     videoEventEmitter={@state.eventEmitter}/>
        {segmentEffortOverlay}
      </div>
    </div>
