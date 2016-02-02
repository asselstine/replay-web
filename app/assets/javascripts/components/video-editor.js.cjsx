@VideoEditor = React.createClass
  displayName: 'VideoEditor'

  propTypes:
    video: React.PropTypes.object.isRequired
    csrf_token: React.PropTypes.string.isRequired

  getInitialState: ->
    currentTime: 0
    loaded: false

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

    vidElem.addEventListener 'canplaythrough', (e) =>
      console.debug("canplaythrough")
      @setState duration: e.target.duration, loaded: true, =>
        @updateAdjustedTimes()

  updateAdjustedTimes: ->
    dateString = @state.date + " " + @state.timestamp + @state.timezone
    timestamp = moment(new Date(dateString))
    if timestamp.isValid()
      adjustedStartTime = timestamp.clone().subtract(@state.currentTime * 1000.0, 'ms')
      adjustedEndTime = adjustedStartTime.clone().add(@state.duration * 1000.0, 'ms')
      @setState(
        start_at: adjustedStartTime.utc().toISOString()
        end_at: adjustedEndTime.utc().toISOString()
      )

  render: ->
    disabled = false # !@state.start_at || !@state.end_at
    currentTimeMs = @state.currentTime * 1000
    duration_ms = @state.duration * 1000 if @state.duration
    <div>
      {@state.loaded &&
        <h3>{@props.video.filename}</h3>
      }
      {@props.video.complete &&
        <div>
          <video controls='true' ref={@videoRef} preload='true'>
            {@props.video.webm_url &&
              <source src={@props.video.webm_url} type='video/webm'/>
            }
            {@props.video.mp4_url &&
              <source src={@props.video.mp4_url} type='video/mp4'/>
            }
          </video>
          <div className='controls'>
            <span>
              Current Time: {currentTimeMs}ms
            </span>
            <h4>Enter the timecode</h4>
            <form action={Routes.video_path(id: @props.video.id)} method='post'>
              <input name="_method" type="hidden" value="patch" />
              <input name="utf8" type="hidden" value="&#x2713;" />
              <input name="authenticity_token" type="hidden" value={@props.csrf_token} />

              <input type='hidden' name='method' value='patch'/>
              <input type='hidden' name='video[duration_ms]' value={duration_ms} />
              <input type='hidden' name='video[start_at]' defaultValue={@props.video.start_at} value={@state.start_at} />
              <input type='hidden' name='video[end_at]' defaultValue={@props.video.end_at} value={@state.end_at} />

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
      {!@props.video.complete &&
        <p>{@props.video.status} {@props.video.message}</p>
      }
    </div>
