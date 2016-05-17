moment = require('moment')

module.exports = React.createClass
  displayName: 'UploadEditor'

  propTypes:
    upload: React.PropTypes.object.isRequired
    csrf_token: React.PropTypes.string.isRequired

  getInitialState: ->
    currentTime: 0
    loaded: false
    start_at: @props.upload.start_at
    end_at: @props.upload.end_at

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

  submit: (e) ->
    $.ajax(
      url: e.target.action
      data: $(e.target).serialize()
    ).done (data, xhr, status) =>
      window.location = Routes.uploads_path()
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
          <VideoPlayer video={@props.upload.video}
                       onTimeUpdate={@handleTimeUpdate}
                       onCanPlayThrough={@handleCanPlayThrough}
                       canFlip={true}/>
          <div className='controls'>
            <span>
              Current Time: {currentTimeMs}ms
            </span>
            <h4>Enter new timecode</h4>
            <form action={Routes.upload_path(id: @props.upload.id)} method='post' onSubmit={@submit}>
              <input name="_method" type="hidden" value="patch" />
              <input name="utf8" type="hidden" value="&#x2713;" />
              <input name="authenticity_token" type="hidden" value={@props.csrf_token} />
              <input type='hidden' name='upload[start_at]' value={@state.start_at} />
              <input type='hidden' name='upload[end_at]' value={@state.end_at} />

              <input type='text' name='date' data-provide='datepicker' data-date-format="mm-dd-yyyy" placeholder='mm-dd-year' onBlur={@onChangeDate}/>
              <input type='text' name='timezone' placeholder='-8:00' onChange={@onChangeTimezone}/>
              <input type='text' name='timestamp' placeholder='12:43:05.232' onChange={@onChangeTimestamp}/>

              <h5>Adjusted Times</h5>
              <p>
                Start time: {@state.start_at}
                <br/>
                End Time: {@state.end_at}
              </p>
              <input type='submit' disabled={disabled} value='Set'/>
            </form>
          </div>
        </div>
      }
      {!@props.upload.video.file_url &&
        <p>File has not yet been processed.</p>
      }
    </div>
