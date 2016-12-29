moment = require('moment')
VideoUploadModal = require('./video-upload-modal')
JobRow = require('./job-row')
VideoThumb = require('./video-thumb')

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
      <VideoThumb video={@props.upload.video}/>
      <VideoUploadModal upload={@props.upload}
                       isOpen={@state.editModalIsOpen}
                       onRequestClose={@closeEditModal}
                       onSuccess={@closeEditModal}/>
    </div>
