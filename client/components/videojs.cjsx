module.exports = React.createClass
  displayName: 'VideoJS'

  propTypes:
    video: React.PropTypes.object.isRequired

  videoRef: (ref) ->
    @videoRef = ReactDOM.findDOMNode(ref)

  onVideoPlayerReady: ->
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
