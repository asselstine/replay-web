cx = require('classnames')
Select = require('react-select')
raf = require('raf')
_ = require('lodash')
EventEmitter = require('wolfy87-eventemitter')

module.exports = React.createClass
  displayName: 'VideoPlayer'

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
    console.debug('seek')
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
      console.debug('raf')
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
    # console.debug('init')
    if Hls.isSupported() && @props.video.playlists.length > 0
      @hls = new Hls({
        debug: false
      })
      @hls.attachMedia(@vidElem)
      @hls.on Hls.Events.MANIFEST_PARSED, () =>
        @vidElem.play()

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

  onChangeLevel: (option) ->
    @hls.currentLevel = option.value
    @setState
      currentLevel: option.value

  render: ->
    flipClass = if @state.flip then 'flip' else ''
    flip = <a className='btn btn-primary' href='javascript:;' onClick={@flip}>Flip</a> if @props.canFlip

    source_url = if @props.video.playlists.length == 0
      @props.video.file_url
    else
      @props.video.playlists[0].file_url

    levelOptions = [
      { label: 'auto', value: -1 },
      { label: 'sd', value: 0 },
      { label: 'hd', value: 1 }
    ]

    levelOptionsDom = <div>
      <Select options={levelOptions}
              value={@state.currentLevel}
              clearable={false}
              multi={false}
              onChange={@onChangeLevel}/>
    </div>

    <div className={cx('video-player', 'canplaythrough': @state.canPlayThrough)}>
      <div className='video-container' ref={@videoContainerRef}>
        <video controls autoPlay
               ref={@videoRef}
               preload={false}
               className='video-player'>
          <source src={source_url}/>
        </video>
      </div>
      {flip}
      <div className='scrubber' style={@getScrubStyle(@state.currentTimeMs)}>
      </div>

      {@props.video.scrub_images.map (url) ->
        <img src={url} style={'display': 'none'} key={url}/>
      }
    </div>
