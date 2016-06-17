_ = require('lodash')
MapBrowser = require('./map-browser')
DraftRoute = require('./draft-route')

module.exports = React.createClass
  displayName: 'VideoDraft'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired

  getInitialState: ->
    throttledHandleProgressTime: _.throttle(@handleProgressTime, 250)

  handleProgressTime: (time, draft) ->
    seconds = (time - draft.start_at_f)
    @videoPlayer.seek(seconds) if @videoPlayer

  videoPlayerRef: (ref) ->
    @videoPlayer = ref

  mapBrowserRef: (ref) ->
    @mapBrowser = ref

  videoTimeupdate: (e) ->
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
                      ref={@mapBrowserRef}>
              <DraftRoute key={@props.videoDraft.id}
                          onProgressTime={@state.throttledHandleProgressTime}
                          draft={@props.videoDraft}/>
          </MapBrowser>
        </div>
      </div>
    </div>
