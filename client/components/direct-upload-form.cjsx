ReactDOM = require('react-dom')
_ = require('lodash/core')

module.exports = React.createClass
  displayName: 'DirectUploadForm'

  propTypes:
    onStart: React.PropTypes.func
    onFail: React.PropTypes.func
    onUpload: React.PropTypes.func.isRequired
    removeCompletedProgressBar: React.PropTypes.bool
    multipleFiles: React.PropTypes.bool
    fileTypes:  React.PropTypes.array

  showSelectionDialog: ->
    $(@form).find('.direct-upload-form__file-input').click()

  getDefaultProps: ->
    onStart: (->)
    onFail: (->)
    removeCompletedProgressBar: true
    multipleFiles: false
    fileTypes: []

  getInitialState: ->
    filenames: []

  refS3Form: (obj) ->
    @form = ReactDOM.findDOMNode(obj)

  refProgressBar: (obj) ->
    @progressBar = ReactDOM.findDOMNode(obj)

  beforeAdd: (file) ->
    return true if _.isEmpty(@props.fileTypes)
    result = _.includes(@props.fileTypes, file.type)
    message.error('Invalid file type: ' + file.type) unless result
    result

  componentDidMount: ->
    multiple = ''
    multiple = "multiple='true'" if @props.multipleFiles
    @fileInput = $("<input type='file' name='file' id='file' class='direct-upload-form__file-input' #{multiple}/>")
    @fileInputContainer = $(@form).find('.fileinput')
    @fileInputContainer.append(@fileInput)
    $(@form).S3Uploader(
      remove_completed_progress_bar: @props.removeCompletedProgressBar
      progress_bar_target: $(@progressBar)
      remove_failed_progress_bar: @props.removeCompletedProgressBar
      allow_multiple_files: @props.multipleFiles,
      before_add: @beforeAdd
    )
      .bind 's3_uploads_start', (e, content) =>
        @setState
          filenames: []
        @props.onStart(@fileInput[0].files)
        @fileInputContainer.hide()
      .bind 's3_upload_failed', (e, content) =>
        @props.onFail(content.filename, content.error_thrown)
        @fileInputContainer.show()
      .bind 's3_upload_complete', (e, content) =>
        @setState
          filenames: @state.filenames.concat([content.filename])
        @props.onUpload(content.filename, content)
        @fileInputContainer.show()

  render: ->
    inputs = (<input type='hidden' name={field} value={value} key={field}/> for field, value of replayConstants.directUploadConfig.fields)
    <form ref={@refS3Form} encType="multipart/form-data" action={replayConstants.directUploadConfig.url} className='direct-upload-form'>
      <input name="utf8" type="hidden" value="✓"/>
      {inputs}
      <div className='fileinput'>
      </div>
      <div className='direct-upload-form__progress-container' ref={@refProgressBar}>
        <div className='progress'>
          <div className='bar'>
          </div>
        </div>
      </div>
    </form>
