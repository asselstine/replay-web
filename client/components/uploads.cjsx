_ = require('lodash/core')
UploadTile = require('./upload-tile')
VideoUploadTile = require('./video-upload-tile')
PhotoUploadTile = require('./photo-upload-tile')
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
    tiles = _.map(@state.uploads, (upload) ->
      <div className='col-sm-3' key={upload.id}>
        {switch upload.type
          when 'VideoUpload' then <VideoUploadTile upload={upload}/>
          when 'PhotoUpload' then <PhotoUploadTile upload={upload}/>
          else <UploadTile upload={upload}/>}
      </div>
    )

    <div className='uploads container'>
      <div className='row'>
        <div className='col-xs-12'>
          <p>
            <a href='javascript:;' onClick={@openCreateModal} className='btn btn-primary'>Upload</a>
          </p>
          <NewUploadModal isOpen={@state.newModalIsOpen}
                          onRequestClose={@closeCreateModal}
                          onSuccess={@onUploadSuccess}
                          setups={@props.setups}/>
        </div>
      </div>
      <div className='row'>
        {tiles}
      </div>
    </div>
