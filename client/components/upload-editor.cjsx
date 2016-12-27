moment = require('moment')

module.exports = React.createClass
  displayName: 'UploadEditor'

  propTypes:
    upload: React.PropTypes.object.isRequired
    onSuccess: React.PropTypes.func.isRequired

  getInitialState: ->
    currentTime: 0
    loaded: false
    start_at: @props.upload.video.start_at
    end_at: @props.upload.video.end_at

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

  handleTimeUpdate: (currentTime) ->
    @setState currentTime: currentTime, =>
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

  submit: ->
    $.ajax(
      url: Routes.upload_path(id: @props.upload.id)
      data:
        upload:
          start_at: @state.start_at
          end_at: @state.end_at
    ).done (data, xhr, status) =>
      @props.onSuccess(data)
     .fail (xhr, status, msg) ->
       message.ajaxFail(xhr, status, msg)

  render: ->
    disabled = false # !@state.start_at || !@state.end_at
    currentTimeMs = @state.currentTime * 1000
    duration_ms = @props.upload.video.duration * 1000 if @props.upload.video.duration
    <div>
      {@state.loaded &&
        <h3>{@props.upload.video.filename}</h3>
      }
      {@props.upload.video.file_url &&
        <div>
          <VideoJsPlayer video={@props.upload.video}
                       onTimeUpdate={@handleTimeUpdate}
                       onCanPlayThrough={@handleCanPlayThrough}
                       canFlip={true}/>
          <div className='controls'>
            <span>
              Current Time: {currentTimeMs}ms
            </span>
            <h4>Enter new timecode</h4>
            <form onSubmit={@submit}>
              <input type='text' name='date' data-provide='datepicker' data-date-format="mm-dd-yyyy" placeholder='mm-dd-year' onBlur={@onChangeDate}/>
              <input type='text' name='timezone' placeholder='-8:00' onChange={@onChangeTimezone}/>
              <input type='text' name='timestamp' placeholder='12:43:05.232' onChange={@onChangeTimestamp}/>
              <h5>Adjusted Times</h5>
              <p>
                Start time: {@state.start_at}
                <br/>
                End Time: {@state.end_at}
              </p>
              <input className='btn btn-primary' type='submit' disabled={disabled} value='Save'/>
            </form>
          </div>
        </div>
      }
      {!@props.upload.video.file_url &&
        <p>File has not yet been processed.</p>
      }
    </div>
