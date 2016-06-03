moment = require('moment')
VideoUploadModal = require('./video-upload-modal')

module.exports = React.createClass
  displayName: 'VideoUploadTile'

  propTypes:
    upload: React.PropTypes.object

  getInitialState: ->
    editModalIsOpen: false

  openEditModal: ->
    @setState(editModalIsOpen: true)

  closeEditModal: ->
    @setState(editModalIsOpen: false)

  render: ->
    <div data-upload-id={@props.upload.id} className='video-upload-tile tile' onClick={@openEditModal}>
      <img className='tile__img' src={@props.upload.video.thumbnail.small_url}/>
      <p>
        <small>{@props.upload.video.start_at}</small>
      </p>
      <p>
        {@props.upload.filename}
      </p>
      <VideoUploadModal upload={@props.upload}
                       isOpen={@state.editModalIsOpen}
                       onRequestClose={@closeEditModal}
                       onSuccess={@closeEditModal}/>
    </div>
