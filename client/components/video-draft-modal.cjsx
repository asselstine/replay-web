Modal = require('react-modal')
ModalStyle = require('../util/modal-default-style')
MapBrowser = require('./map-browser')
DraftRoute = require('./draft-route')

module.exports = React.createClass
  displayName: 'VideoDraftModal'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired
    isOpen: React.PropTypes.bool.isRequired
    onRequestClose: React.PropTypes.func.isRequired

  handleProgressTime: (time, draft) ->
    seconds = (time - draft.activity.timestamps_f[0])
    # @videoPlayer.seek(seconds) if @videoPlayer

  videoPlayerRef: (ref) ->
    @videoPlayer = ref

  render: ->
    <Modal className='video-draft-modal modal-dialog modal-lg'
           style={ModalStyle}
           isOpen={@props.isOpen}
           onRequestClose={@props.onRequestClose}>
      <div className='modal-content'>
        <div className='modal-header'>
          <h3>{@props.videoDraft.activity.strava_name}</h3>
        </div>
        <div className='modal-body'>
          <div className='row'>
            <div className='col-sm-8'>
              {@props.videoDraft.video.file_url &&
                  <VideoPlayer video={@props.videoDraft.video}
                               canFlip={false}
                               ref={@videoPlayerRef}/>
              }
            </div>
            <div className='col-sm-4'>
              <MapBrowser drafts={[@props.videoDraft]}
                          onProgressTime={@handleProgressTime}>
                <DraftRoute key={@props.videoDraft.id}
                            draft={@props.videoDraft}/>
              </MapBrowser>
            </div>
          </div>
        </div>
        <div className='modal-footer'>
          <div className='pull-right'>
            <a href='javascript:;' className='btn btn-default' onClick={@props.onRequestClose}>Close</a>
          </div>
        </div>
      </div>
    </Modal>
