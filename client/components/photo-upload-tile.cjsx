PhotoUploadModal = require('./photo-upload-modal')

module.exports = React.createClass
  displayName: 'PhotoUploadTile'

  propTypes:
    upload: React.PropTypes.object

  getInitialState: ->
    photoModalIsOpen: false

  openPhotoModal: ->
    @setState(photoModalIsOpen: true)

  closePhotoModal: ->
    @setState(photoModalIsOpen: false)

  render: ->
    <div data-upload-id={@props.upload.id} className='pending-upload-tile tile' onClick={@openPhotoModal}>
      <img className='tile__img' src={@props.upload.photo.small_url}/>
      <p>
        <small>{@props.upload.photo.timestamp}</small>
      </p>
      <p>
        {@props.upload.filename}
      </p>
      <PhotoUploadModal upload={@props.upload}
                        isOpen={@state.photoModalIsOpen}
                        onRequestClose={@closePhotoModal}/>
    </div>
