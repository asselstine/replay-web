_ = require('lodash')

module.exports = React.createClass
  displayName: 'VideoDraft'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  getInitialState: ->
    throttledHandleProgressTime: _.throttle(@handleProgressTime, 250)

  handleProgressTime: (time, draft) ->
    console.debug('go to ', time)
    seconds = (time - draft.activity.timestamps_f[0])
    @videoPlayer.seek(seconds) if @videoPlayer

  videoPlayerRef: (ref) ->
    @videoPlayer = ref

  mapBrowserRef: (ref) ->
    @mapBrowser = ref

  videoTimeupdate: (e) ->
    debugger
    # @mapBrowser.seek(seconds)

  render: ->
    <div className='video-draft'>
      <h3>{@props.videoDraft.activity.strava_name}</h3>
      <div className='row'>
        <div className='col-sm-8'>
          {@props.videoDraft.video.file_url &&
              <VideoPlayer video={@props.videoDraft.video}
                           canFlip={false}
                           ref={@videoPlayerRef}
                           onTimeUpdate={@videoTimeupdate}/>
          }
        </div>
        <div className='col-sm-4'>
          <MapBrowser drafts={[@props.videoDraft]}
                      onProgressTime={@state.throttledHandleProgressTime}
                      ref={@mapBrowserRef}/>
        </div>
      </div>
    </div>
