Select = require('react-select')
raf = require('raf')

module.exports = React.createClass
  displayName: 'VideoPlayer'

  propTypes:
    video: React.PropTypes.object.isRequired
    onTimeUpdate: React.PropTypes.func
    onCanPlayThrough: React.PropTypes.func
    canFlip: React.PropTypes.bool

  getDefaultProps: ->
    canFlip: false

  getInitialState: ->
    flip: false
    currentTimeMs: 0
    currentLevel: -1

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

  videoTimeUpdate: (e) ->
    @setState
      currentTimeMs: +(e.target.currentTime * 1000)
    if @props.onTimeUpdate
      @props.onTimeUpdate(e)

  rafTick: (timestamp) ->
    return unless @vidElem
    # do something
    raf(@rafTick)

  videoCanPlayThrough: (e) ->
    if @props.onCanPlayThrough
      @props.onCanPlayThrough(e)

  onTimeUpdate: ->
    @props.onTimeUpdate(@vidElem.currentTime)

  videoSeeking: (e) ->
    @setState
      currentTimeMs: @vidElem.currentTime * 1000,
      @onTimeUpdate

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
      @hls.loadSource(@props.video.playlists[0].file_url)
      @hls.attachMedia(@vidElem)
      @hls.on Hls.Events.MANIFEST_PARSED, () =>
        @vidElem.play()
      # console.debug('nextLevel: ', @hls.nextLevel)
      # console.debug('loadLevel: ', @hls.loadLevel)
      # console.debug('capLevel: ', @hls.capLevel)

  componentDidMount: ->
    # @vidElem.addEventListener 'timeupdate', @videoTimeUpdate
    @vidElem.addEventListener 'canplaythrough', @videoCanPlayThrough
    @vidElem.addEventListener 'seeking', @videoSeeking
    @vidElem.addEventListener 'seeked', @videoSeeking
    # raf(@rafTick)
    @initVideoPlayer()

  componentWillUnmount: ->
    return unless @vidElem
    @hls.destroy() if @hls
    # @vidElem.removeEventListener 'timeupdate', @videoTimeUpdate
    @vidElem.removeEventListener 'canplaythrough', @videoCanPlayThrough
    @vidElem.removeEventListener 'seeking', @videoSeeking
    @vidElem.removeEventListener 'seeked', @videoSeeking

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

    if @props.video.playlists.length == 0
      source = <source src={@props.video.file_url}/>

    levelOptions = [
      { label: 'auto', value: -1 },
      { label: 'sd', value: 0 },
      { label: 'hd', value: 1 }
    ]

    <div>
      <div className='video-container' ref={@videoContainerRef}>
        <video controls autoplay
               ref={@videoRef}
               preload={false}
               className='video-player'>
          {source}
        </video>
        <div>
          <Select options={levelOptions}
                  value={@state.currentLevel}
                  clearable={false}
                  multi={false}
                  onChange={@onChangeLevel}/>
        </div>
      </div>
      {flip}
      <div className='scrubber' style={@getScrubStyle(@state.currentTimeMs)}>
      </div>

      {@props.video.scrub_images.map (url) ->
        <img src={url} style={'display': 'none'} key={url}/>
      }
    </div>
