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
    modalIsOpen: false

  openModal: ->
    @setState(modalIsOpen: true)

  closeModal: ->
    @setState(modalIsOpen: false)

  onUploadSuccess: (upload) ->
    @setState
      uploads: @state.uploads.concat([upload]), =>
      @closeModal()

  render: ->
    rows = _.map(@state.uploads, (upload) ->
      <UploadRow upload={upload} key={upload.id}/>
    )

    <div className='uploads container'>
      <div className='row'>
        <div className='col-xs-12'>
          <a href='javascript:;' onClick={@openModal} className='btn btn-primary'>Upload</a>
          <NewUploadModal isOpen={@state.modalIsOpen}
                          onRequestClose={@closeModal}
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
