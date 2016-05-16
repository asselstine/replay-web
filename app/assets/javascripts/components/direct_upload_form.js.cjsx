@DirectUploadForm = React.createClass
  displayName: 'DirectUploadForm'

  propTypes:
    onStart: React.PropTypes.func.isRequired
    onFail: React.PropTypes.func.isRequired
    onUpload: React.PropTypes.func.isRequired
    removeCompletedProgressBar: React.PropTypes.bool
    multipleFiles: React.PropTypes.bool

  showSelectionDialog: ->
    $(@form).find('.direct-upload-form__file-input').click()

  getDefaultProps: ->
    multipleFiles: false
    removeCompletedProgressBar: true

  getInitialState: ->
    filenames: []

  refS3Form: (obj) ->
    @form = ReactDOM.findDOMNode(obj)

  refProgressBar: (obj) ->
    @progressBar = ReactDOM.findDOMNode(obj)

  componentDidMount: ->
    multiple = ''
    multiple = "multiple='true'" if @props.multipleFiles
    fileInput = $("<input type='file' name='file' id='file' class='direct-upload-form__file-input' #{multiple}/>")
    $(@form).find('.fileinput').append(fileInput)
    $(@form).S3Uploader(
      remove_completed_progress_bar: @props.removeCompletedProgressBar
      progress_bar_target: $(@progressBar)
      remove_failed_progress_bar: @props.removeCompletedProgressBar
      allow_multiple_files: @props.multipleFiles
    )
      .bind 's3_uploads_start', (e) =>
        @setState
          filenames: []
        @props.onStart()
      .bind 's3_upload_failed', (e, content) =>
        @props.onFail(content.filename, content.error_thrown)
      .bind 's3_upload_complete', (e, content) =>
        @setState
          filenames: @state.filenames.concat([content.filename])
        @props.onUpload(content.filename, content.url)

  render: ->
    inputs = (<input type='hidden' name={field} value={value} key={field}/> for field, value of vey_constants.direct_upload_config.fields)
    <form ref={@refS3Form} encType="multipart/form-data" action={vey_constants.direct_upload_config.url} className='direct-upload-form'>
      <input name="utf8" type="hidden" value="✓"/>
      {inputs}
      <div className='fileinput'>
      </div>
      <div className='direct-upload-form__progress-container' ref={@refProgressBar}>
      </div>
    </form>
