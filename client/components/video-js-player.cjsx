cx = require('classnames')
Select = require('react-select')
raf = require('raf')
_ = require('lodash')
EventEmitter = require('wolfy87-eventemitter')

module.exports = React.createClass
  displayName: 'VideoJsPlayer'

  propTypes:
    video: React.PropTypes.object.isRequired
    onTimeUpdate: React.PropTypes.func
    onCanPlayThrough: React.PropTypes.func
    canFlip: React.PropTypes.bool
    currentTime: React.PropTypes.number
    start: React.PropTypes.number
    duration: React.PropTypes.number
    loop: React.PropTypes.bool
    videoEventEmitter: React.PropTypes.object

  getDefaultProps: ->
    start: null
    duration: null
    loop: false
    canFlip: false
    onTimeUpdate: (->)
    onCanPlayThrough: (->)
    videoEventEmitter: new EventEmitter()

  getInitialState: ->
    flip: false
    currentTimeMs: 0
    currentLevel: -1
    emitRafTick: _.throttle(@emitRafTick, 80)
    canPlayThrough: false

  videoRef: (ref) ->
    if ref == null
      @vidElem = null
    else
      @vidElem = ReactDOM.findDOMNode(ref)

  videoContainerRef: (ref) ->
    if ref == null
      @videoContainer = null
    else
      @videoContainer = ReactDOM.findDOMNode(ref)

  seek: (time) ->
    @vidElem.currentTime = time

  flip: ->
    @setState
      flip: !@state.flip

  enableRafTick: ->
    return if @enableRaf
    @enableRaf = true
    @props.videoEventEmitter.emit('enableRaf')
    raf(@rafTick)

  emitRafTick: ->
    return unless @vidElem
    @props.videoEventEmitter.emit('videoRafTick', @vidElem.currentTime)

  disableRafTick: ->
    @enableRaf = false
    @props.videoEventEmitter.emit('disableRaf')

  rafTick: (timestamp) ->
    return unless @vidElem
    if @props.loop &&
       @props.start && @props.duration &&
       @vidElem.currentTime > @props.duration
      @vidElem.currentTime = @props.start
    @state.emitRafTick()
    raf(@rafTick) if @enableRaf

  videoPlaying: ->
    @enableRafTick()

  videoPause: ->
    @disableRafTick()

  videoCanPlayThrough: (e) ->
    @setState
      canPlayThrough: true
    if @props.onCanPlayThrough
      @props.onCanPlayThrough(e)

  videoSeeking: (e) ->
    @onTimeUpdate(e.target.currentTime)

  videoTimeUpdate: (e) ->
    @onTimeUpdate(e.target.currentTime)

  onTimeUpdate: (seconds) ->
    @setState
      currentTimeMs: +(seconds * 1000)
    @props.onTimeUpdate(seconds)
    @props.videoEventEmitter.emit('videoRafTick', seconds) if @props.videoEventEmitter

  sourceUrl: ->
    if @props.video.playlists.length > 0
      @props.video.playlists[0].file_url
    else
      @props.video.file_url

  initVideoPlayer: ->
    that = @
    @player = videojs(@vidElem, {}, ->
      this.src(that.props.video.outputs.map (output) ->
        src: output.signed_url
        type: "video/#{output.container_format}"
      )
    )

  componentWillReceiveProps: (nextProps) ->
    @vidElem.currentTime = nextProps.currentTime if nextProps.currentTime

  componentDidMount: ->
    @vidElem.addEventListener 'timeupdate', @videoTimeUpdate
    @vidElem.addEventListener 'canplaythrough', @videoCanPlayThrough
    @vidElem.addEventListener 'seeking', @videoSeeking
    @vidElem.addEventListener 'seeked', @videoSeeking
    @vidElem.addEventListener 'playing', @videoPlaying
    @vidElem.addEventListener 'pause', @videoPause
    @vidElem.currentTime = @props.currentTime if @props.currentTime
    @initVideoPlayer()

  componentWillUnmount: ->
    return unless @vidElem
    @hls.destroy() if @hls
    @vidElem.removeEventListener 'timeupdate', @videoTimeUpdate
    @vidElem.removeEventListener 'canplaythrough', @videoCanPlayThrough
    @vidElem.removeEventListener 'seeking', @videoSeeking
    @vidElem.removeEventListener 'seeked', @videoSeeking
    @vidElem.removeEventListener 'playing', @videoPlaying
    @vidElem.removeEventListener 'pause', @videoPause

  getScrubImageSrc: (timeMs) ->
    # one per second
    scrubFrameIndex = Math.floor(timeMs / 1000)
    # 40 per page
    scrubPageIndex = Math.floor(scrubFrameIndex / 30)
    @props.video.scrub_images[scrubPageIndex]

  getScrubImageOffset: (timeMs) ->
    # one per second
    scrubFrameIndex = Math.floor(timeMs / 1000)
    # 40 per page, 480px wide
    scrubPageOffset = (scrubFrameIndex % 30) * 480

  getScrubStyle: (timeMs) ->
    scrubSrc = @getScrubImageSrc(@state.currentTimeMs)
    scrubOffset = @getScrubImageOffset(@state.currentTimeMs)
    if scrubSrc
      {
        width: '480px',
        height: '270px',
        backgroundImage: "url(#{scrubSrc})",
        backgroundPosition: "-#{scrubOffset}px 0"
      }
    else
      {
        width: '0px',
        height: '0px'
      }

  render: ->
    <div className={cx('video-player', 'canplaythrough': @state.canPlayThrough)}>
      <div ref={@videoContainerRef}>
        <video controls
               ref={@videoRef}
               preload={false}
               className='video-js vjs-default-skin vjs-16-9'>
        </video>
      </div>
      <div className='scrubber' style={@getScrubStyle(@state.currentTimeMs)}>
      </div>

      {@props.video.scrub_images.map (url) ->
        <img src={url} style={'display': 'none'} key={url}/>
      }
    </div>
