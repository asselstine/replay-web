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
    editModal = if @props.upload.type == 'VideoUpload'
      <EditUploadModal upload={@props.upload}
                       isOpen={@state.editModalIsOpen}
                       onRequestClose={@closeEditModal}
                       onSuccess={@closeEditModal}/>

    <div className='upload-row row'>
      <div className='col-xs-5'>
        <a href='javascript:;' onClick={@openEditModal}>{@props.upload.filename}</a>
        {editModal}
      </div>
      <div className='col-xs-3'>
      </div>
      <div className='col-xs-4'>
      </div>
    </div>
