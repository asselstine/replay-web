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

  videoRef: (ref) ->
    if ref == null
      @vidElem = null
    else
      @vidElem = ReactDOM.findDOMNode(ref)

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

  videoCanPlayThrough: (e) ->
    if @props.onCanPlayThrough
      @props.onCanPlayThrough(e)

  videoSeeking: (e) ->
    @setState
      currentTimeMs: @vidElem.currentTime * 1000

  onVideoPlayerReady: ->
    if @props.video.playlists.length > 0
      @videoPlayer.src({
        'type': 'application/x-mpegURL',
        'src': @props.video.playlists[0].file_url
      })
    else
      @videoPlayer.src({
        'src': @props.video.file_url
      })

  componentDidMount: ->
    @vidElem.addEventListener 'timeupdate', @videoTimeUpdate
    @vidElem.addEventListener 'canplaythrough', @videoCanPlayThrough
    @vidElem.addEventListener 'seeking', @videoSeeking
    @vidElem.addEventListener 'seeked', @videoSeeked
    @videoPlayer = videojs(@vidElem, {}).ready(@onVideoPlayerReady)

  componentWillUnmount: ->
    return unless @vidElem
    @vidElem.removeEventListener 'timeupdate', @videoTimeUpdate
    @vidElem.removeEventListener 'canplaythrough', @videoCanPlayThrough
    @vidElem.removeEventListener 'seeking', @videoSeeking
    @vidElem.removeEventListener 'seeked', @videoSeeked

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
    flipClass = if @state.flip then 'flip' else ''
    flip = <a className='btn btn-primary' href='javascript:;' onClick={@flip}>Flip</a> if @props.canFlip
    <div>
      <div className='video-container'>
        <video controls='true'
               ref={@videoRef}
               preload='false'
               className={'video-js vjs-default-skin vjs-16-9 vjs-big-play-centered video-player ' + flipClass}>
        </video>
      </div>
      {flip}
      <div className='scrubber' style={@getScrubStyle(@state.currentTimeMs)}>
      </div>

      {@props.video.scrub_images.map (url) ->
        <img src={url} style={'display': 'none'} key={url}/>
      }
    </div>
