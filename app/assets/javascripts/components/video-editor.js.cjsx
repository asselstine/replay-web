@VideoEditor = React.createClass
  displayName: 'VideoEditor'

  propTypes:
    video: React.PropTypes.object.isRequired

  getInitialState: ->
    currentTimeMs: 0

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

  videoRef: (ref) ->
    vidElem = ReactDOM.findDOMNode(ref)
    vidElem.addEventListener 'timeupdate', (e) =>
      @setState(currentTime: e.target.currentTime, =>
        @updateAdjustedTimes())

    vidElem.addEventListener 'loadeddata', (e) =>
       @setState(duration: e.target.duration, =>
         @updateAdjustedTimes())
         
  updateAdjustedTimes: ->
    dateString = @state.date + " " + @state.timestamp + @state.timezone
    timestamp = moment(new Date(dateString))
    if timestamp.isValid()
      adjustedStartTime = timestamp.clone().subtract(@state.currentTime * 1000.0, 'ms')
      adjustedEndTime = adjustedStartTime.clone().add(@state.duration * 1000.0, 'ms')
      @setState(
        adjustedStartTime: adjustedStartTime
        adjustedEndTime: adjustedEndTime
      )

  handleFormSubmit: (e) ->
    e.preventDefault()
    $.ajax
      url: e.target.getAttribute('action')
      method: 'PUT'
      data:
        video:
          start_at: @state.adjustedStartTime.toISOString()
          end_at: @state.adjustedEndTime.toISOString()
          duration_ms: @state.duration * 1000
      success: (data, xhr, status) =>
        console.debug("Saved!")
      error: (xhr, status) =>
        console.error('Could not save: ', xhr)

  render: ->
    adjustedStartTime = @state.adjustedStartTime.toISOString() if @state.adjustedStartTime
    adjustedEndTime = @state.adjustedEndTime.toISOString() if @state.adjustedEndTime
    disabled = !adjustedStartTime || !adjustedEndTime
    <div>
      <h3>{@props.video.filename}</h3>
      {@props.video.complete &&
        <div>
          <video controls='true' ref={@videoRef}>
            <source src={@props.video.webm_url} type='video/webm'/>
            <source src={@props.video.mp4_url} type='video/mp4'/>
          </video>
          <div className='controls'>
            <span>
              Current Time MS: {@state.currentTimeMs}
            </span>
            <h4>Enter the timecode</h4>
            <form action={Routes.video_path(id: @props.video.id)} onSubmit={@handleFormSubmit}>
              <input type='text' name='date' data-provide='datepicker' data-date-format="mm-dd-yyyy" placeholder='mm/dd/year' onBlur={@onChangeDate}/>
              <input type='text' name='timezone' placeholder='-8:00' onChange={@onChangeTimezone}/>
              <input type='text' name='timestamp' placeholder='12:43:05.232' onChange={@onChangeTimestamp}/>
              <h5>Adjusted Times</h5>
              <p>
                Start time: {adjustedStartTime}
                <br/>
                End Time: {adjustedEndTime}
              </p>
              <input type='submit' disabled={disabled} value='Set'/>
            </form>
          </div>
        </div>
      }
      {!@props.video.complete &&
        <p>{@props.video.status} {@props.video.message}</p>
      }
    </div>
