EditUploadModal = require('./edit-upload-modal')

module.exports = React.createClass
  displayName: 'UploadRow'

  propTypes:
    upload: React.PropTypes.object

  getInitialState: ->
    editModalIsOpen: false

  openEditModal: ->
    @setState(editModalIsOpen: true)

  closeEditModal: ->
    @setState(editModalIsOpen: false)

  render: ->
    <div className='upload-row row'>
      <div className='col-xs-5'>
        <a href='javascript:;' onClick={@openEditModal}>{@props.upload.video.filename}</a>
        <EditUploadModal upload={@props.upload}
                         isOpen={@state.editModalIsOpen}
                         onRequestClose={@closeEditModal}
                         onSuccess={@closeEditModal}/>
      </div>
      <div className='col-xs-3'>
      </div>
      <div className='col-xs-4'>
      </div>
    </div>
