moment = require('moment')
VideoUploadModal = require('./video-upload-modal')
JobRow = require('./job-row')

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
    if @props.upload.jobs.length > 0
       jobs = @props.upload.jobs.map (job) ->
         <JobRow job={job} key={job.id}/>

    <div data-upload-id={@props.upload.id} className='video-upload-tile tile' onClick={@openEditModal}>
      {jobs}
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
