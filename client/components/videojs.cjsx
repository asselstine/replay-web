module.exports = React.createClass
  displayName: 'VideoJS'

  videoRef: (ref) ->
    @videoRef = ReactDOM.findDOMNode(ref)

  onVideoPlayerReady: ->
    console.debug('ready')
    window.player = @videoPlayer

  componentDidMount: ->
    @videoPlayer = videojs(@videoRef, components: {
        "playToggle": {},
        "fullscreenToggle": {},
        "durationDisplay": {},
        "remainingTimeDisplay": {},
        "progressControl": {},
        "volumeControl": {},
    }).ready(@onVideoPlayerReady)

  render: ->
    <video ref={@videoRef} className="video-js vjs-default-skin" controls>
      <source
       src="gopro4795hls.m3u8"
       type="application/x-mpegURL" />
    </video>
