PhotoUploadModal = require('./photo-upload-modal')

module.exports = React.createClass
  displayName: 'PhotoUploadTile'

  propTypes:
    upload: React.PropTypes.object

  getInitialState: ->
    photoModalIsOpen: false

  openEditModal: ->
    @setState(photoModalIsOpen: true)

  closeEditModal: ->
    @setState(photoModalIsOpen: false)

  render: ->
    <div className='pending-upload-tile tile' onClick={@openEditModal}>
      <img className='tile__img' src={@props.upload.photo.small_url}/>
      <p>
        <small>{@props.upload.photo.timestamp}</small>
      </p>
      <p>
        {@props.upload.filename}
      </p>
      <PhotoUploadModal upload={@props.upload}
                        isOpen={@state.photoModalIsOpen}
                        onRequestClose={@closeEditModal}/>
    </div>
