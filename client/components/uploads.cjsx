_ = require('lodash/core')
UploadRow = require('./upload-row')
NewUploadModal = require('./new-upload-modal')

module.exports = React.createClass
  displayName: 'Uploads'

  propTypes:
    uploads: React.PropTypes.array
    setups: React.PropTypes.array

  getInitialState: ->
    uploads: @props.uploads
    newModalIsOpen: false

  openCreateModal: ->
    @setState(newModalIsOpen: true)

  closeCreateModal: ->
    @setState(newModalIsOpen: false)

  onUploadSuccess: (upload) ->
    @setState
      uploads: @state.uploads.concat([upload]), =>
      @closeCreateModal()

  render: ->
    rows = _.map(@state.uploads, (upload) ->
      <UploadRow upload={upload} key={upload.id}/>
    )

    <div className='uploads container'>
      <div className='row'>
        <div className='col-xs-12'>
          <a href='javascript:;' onClick={@openCreateModal} className='btn btn-primary'>Upload</a>
          <NewUploadModal isOpen={@state.newModalIsOpen}
                          onRequestClose={@closeCreateModal}
                          onSuccess={@onUploadSuccess}
                          setups={@props.setups}/>
        </div>
      </div>
      <div className='row'>
        <div className='col-xs-5'>
          <b>Filename</b>
        </div>
        <div className='col-xs-3'>
          <b>Date Uploaded</b>
        </div>
        <div className='col-xs-4'>
          <b>Controls</b>
        </div>
      </div>
      {rows}
    </div>
