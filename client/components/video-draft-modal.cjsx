Modal = require('react-modal')
ModalStyle = require('../util/modal-default-style')

module.exports = React.createClass
  displayName: 'VideoDraftModal'

  propTypes:
    videoDraft: React.PropTypes.object.isRequired
    isOpen: React.PropTypes.bool.isRequired
    onRequestClose: React.PropTypes.func.isRequired

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
          {@props.videoDraft.video.file_url &&
              <VideoPlayer video={@props.videoDraft.video}
                           canFlip={false}/>
          }
        </div>
        <div className='modal-footer'>
          <div className='pull-right'>
            <a href='javascript:;' className='btn btn-default' onClick={@props.onRequestClose}>Close</a>
          </div>
        </div>
      </div>
    </Modal>
