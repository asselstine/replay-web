_ = require('lodash')
Modal = require('react-modal')
ModalStyle = require('../util/modal-default-style')
moment = require('moment')
Select = require('react-select')

module.exports = React.createClass
  displayName: 'VideoUploadModal'

  propTypes:
    upload: React.PropTypes.object.isRequired
    isOpen: React.PropTypes.bool.isRequired
    onRequestClose: React.PropTypes.func.isRequired
    onSuccess: React.PropTypes.func.isRequired

  getInitialState: ->
    currentTime: 0
    loaded: false
    start_at: @props.upload.video.start_at
    end_at: @props.upload.video.end_at
    rotation: 'rotate_0'

  onChangeDate: (e) ->
    @setState(date: e.target.value, =>
      @updateAdjustedTimes()
    )

  onChangeTimezone: (e) ->
    @setState(timezone: e.target.value, =>
      @updateAdjustedTimes()
    )

  onChangeTimestamp: (e) ->
    @setState(timestamp: e.target.value, =>
      @updateAdjustedTimes()
    )

  onChangeRotation: (option) ->
    @setState rotation: option.value

  handleTimeUpdate: (e) ->
    @setState currentTime: e.target.currentTime, =>
      @updateAdjustedTimes()

  handleCanPlayThrough: (e) ->
    @setState loaded: true, =>
      @updateAdjustedTimes()

  updateAdjustedTimes: ->
    dateString = @state.date + " " + @state.timestamp + @state.timezone
    timestamp = moment(new Date(dateString))
    if timestamp.isValid()
      adjustedStartTime = timestamp.clone().subtract(@state.currentTime * 1000.0, 'ms')
      adjustedEndTime = adjustedStartTime.clone().add(@props.upload.video.duration * 1000.0, 'ms')
      @setState(
        start_at: adjustedStartTime.utc().toISOString()
        end_at: adjustedEndTime.utc().toISOString()
      )

  transcode: ->
    $.ajax
      url: Routes.jobs_path()
      method: 'POST'
      dataType: 'json'
      data:
        job:
          video_id: @props.upload.video.id
          rotation: @state.rotation
    .done (data, xhr, status) =>
      message.success('Created job')
    .fail (xhr, status, msg) =>
      message.ajaxFail(xhr, status, msg)

  submit: ->
    $.ajax(
      url: Routes.upload_path(id: @props.upload.id)
      method: 'PATCH'
      dataType: 'json'
      data:
        upload:
          video_attributes:
            id: @props.upload.video.id
            start_at: @state.start_at
            end_at: @state.end_at
    ).done (data, xhr, status) =>
      message.success(I18n.t('flash.upload.update.success',
                             filename: @props.upload.video.filename))
      @props.onSuccess(data)
     .fail (xhr, status, msg) ->
       message.ajaxFail(xhr, status, msg)

  render: ->
    disabled = false # !@state.start_at || !@state.end_at
    currentTimeMs = @state.currentTime * 1000
    duration_ms = @props.upload.video.duration * 1000 if @props.upload.video.duration
    rotationOptions = _.map window.replayConstants.Job.rotations, (value, key) =>
      { label: I18n.t('models.job.rotation.'+key), value: key }

    <Modal className='video-upload-modal modal-dialog modal-lg'
           style={ModalStyle}
           isOpen={@props.isOpen}
           onRequestClose={@props.onRequestClose}>

      <div className='modal-content'>
        <div className='modal-header'>
          <h3>{@props.upload.video.filename}</h3>
        </div>
        <div className='modal-body'>
          {@props.upload.video.file_url &&
            <div>
              <VideoPlayer video={@props.upload.video}
                           onTimeUpdate={@handleTimeUpdate}
                           onCanPlayThrough={@handleCanPlayThrough}
                           canFlip={true}/>
              <div className='controls'>
                <span>
                  Current Time: {currentTimeMs}ms
                </span>
                <h4>Enter new timecode</h4>
                <input type='text' name='date' data-provide='datepicker' data-date-format="mm-dd-yyyy" placeholder='mm-dd-year' onBlur={@onChangeDate}/>
                <input type='text' name='timezone' placeholder='-8:00' onChange={@onChangeTimezone}/>
                <input type='text' name='timestamp' placeholder='12:43:05.232' onChange={@onChangeTimestamp}/>
                <h5>Adjusted Times</h5>
                <p>
                Start time: {@state.start_at}
                <br/>
                End Time: {@state.end_at}
                </p>
              </div>
            </div>
          }
          <div className='row'>
            <div className='col-sm-3'>
              Rotate
            </div>
            <div className='col-sm-9'>
              <Select multi={false}
                      clearable={false}
                      value={@state.rotation}
                      options={rotationOptions}
                      onChange={@onChangeRotation}/>
            </div>
          </div>
        </div>
        <div className='modal-footer'>
          <div className='pull-right'>
            <a href='javascript:;' className='btn btn-default' onClick={@props.onRequestClose}>Close</a>
            <a href='javascript:;' className='btn btn-primary' onClick={@submit}>Save</a>
            <a href='javascript:;' className='btn btn-default' onClick={@transcode}>Transcode</a>
          </div>
        </div>
      </div>
    </Modal>
