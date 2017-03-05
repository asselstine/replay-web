_ = require('lodash')
moment = require('moment')
ActivityPlayer = require('./activity-player')
VideoJsPlayer = require('./video-js-player')
EventEmitter = require('wolfy87-eventemitter')
SegmentEffortOverlay = require('./segment-effort-overlay')
draftLatLngs = require('../util/draft-latlngs')
latLngsBounds = require('../util/latlngs-bounds')
Map = require('./map')
Path = require('./path')

module.exports = React.createClass
  displayName: 'VideoDraft'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  getInitialState: ->
    eventEmitter: new EventEmitter()
    currentTime: 0

  componentDidMount: ->
    this.state.eventEmitter.on('videoRafTick', @onVideoRafTick)
    efforts = @props.videoDraft.segment_efforts
    if efforts.length
      effort = efforts[0]
      @setState
        currentTime: @videoTime(effort.start_index)
        currentSegmentEffort: effort

  onMapClick: (time) ->
    @setState
      currentTime: time

  onVideoRafTick: (videoTime) ->
    time = moment(@props.videoDraft.activity.start_at).add(videoTime, 'seconds')

  videoTime: (start_index) ->
    segmentStartSecond = @props.videoDraft.activity.timestamps_f[start_index]
    segmentStartAt = moment(@props.videoDraft.activity.start_at).add(segmentStartSecond, 'seconds')
    videoStartAt = moment(@props.videoDraft.video.start_at)
    segmentStartAt.diff(videoStartAt, 'seconds', true)

  render: ->
    latLngs = draftLatLngs(@props.videoDraft)
    bounds = latLngsBounds(latLngs)

    if @state.currentSegmentEffort
      segmentEffortOverlay =
        <SegmentEffortOverlay activity={@props.videoDraft.activity}
                              segmentEffort={@state.currentSegmentEffort}
                              eventEmitter={@state.eventEmitter}/>

    <div className='video-draft'>
      <h3>{@props.videoDraft.name}</h3>
      <div className='row'>
        <div className='col-sm-4 col-lg-3'>
          <Map bounds={bounds}>
            <Path latLngs={latLngs}
                  timestamps={@props.videoDraft.timestamps_f}
                  currentTime={}
                  onClick={@onMapClick}/>
          </Map>
        </div>
        <div className='col-sm-8 col-lg-9'>
          <div className='data-video-player'>
            <VideoJsPlayer video={@props.videoDraft.video}
                           currentTime={@state.currentTime}
                           videoEventEmitter={@state.eventEmitter}/>
            {segmentEffortOverlay}
          </div>
        </div>
      </div>
    </div>
