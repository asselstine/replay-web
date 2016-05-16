Modal = require('react-modal')
CSRF = require('./csrf')
_ = require('lodash')
DirectUploadForm = require('./direct-upload-form')
Select = require('react-select')

module.exports = React.createClass
  displayName: 'NewUpload'

  propTypes:
    setups: React.PropTypes.array.isRequired
    isOpen: React.PropTypes.bool.isRequired
    onRequestClose: React.PropTypes.func.isRequired
    onSuccess: React.PropTypes.func

  getDefaultProps: ->
    onSuccess: (->)

  getInitialState: ->
    url: ''
    filename: ''
    selectedSetups: []

  onStart: (files) ->
    filenames = _.map(files, (file) -> file.name)
    @setState(uploadingFilenames: filenames)

  onFail: (filename, error) ->
    message.error('Could not upload "'+filename+'": ' + error)
    @setState(uploadingFilenames: '')

  onUpload: (filename, url) ->
    @setState(filename: filename, url: url, uploadingFilenames: '')

  onChangeSetup: (options) ->
    @setState(selectedSetups: _.map(options, (option) -> option.value))

  submit: ->
    data = {
      upload: {
        video_attributes: {
          source_url: @state.url,
          filename: @state.filename
        },
        setup_ids: @state.selectedSetups
      }
    }
    $.ajax(
      url: Routes.uploads_path()
      method: 'POST'
      dataType: 'json'
      data: data)
      .done (data, xhr, status) =>
        message.success(I18n.t('flash.upload.create.success',
                               filename: data.video.filename))
        @props.onSuccess(data)
      .fail (xhr, status, msg) ->
        message.ajaxFail(xhr, status, msg)

  render: ->
    disableSubmit = _.isEmpty(@state.url)
    uploading = <i>Uploading {@state.uploadingFilenames.join(', ')}...</i> unless _.isEmpty(@state.uploadingFilenames)
    filename = <b>{@state.filename}</b> unless _.isEmpty(@state.filename)
    selectOptions = _.map(@props.setups, (setup) -> { value: setup.id, label: setup.name })
    fileTypes = [] #['video/mp4']
    <Modal className='new-upload modal-dialog'
           isOpen={@props.isOpen}
           onRequestClose={@props.onRequestClose}>
      <div className='modal-content'>
        <div className='modal-header'>
          <h3>Upload Video</h3>
        </div>
        <div className='modal-body'>
          {uploading}
          {filename}
          <DirectUploadForm onStart={@onStart}
                            onFail={@onFail}
                            onUpload={@onUpload}
                            fileTypes={fileTypes}/>
          <Select multi={true}
                  value={@state.selectedSetups}
                  options={selectOptions}
                  onChange={@onChangeSetup}/>
        </div>
        <div className='modal-footer'>
          <div className='pull-right'>
            <button className='btn btn-default'
                    onClick={@props.onRequestClose}>Close</button>
            <button className='btn btn-primary'
                    onClick={@submit}
                    disabled={disableSubmit}>Upload</button>
          </div>
        </div>
      </div>
    </Modal>
