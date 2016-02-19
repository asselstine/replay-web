@VideoPlayer = React.createClass
  displayName: 'VideoPlayer'

  propTypes:
    video: React.PropTypes.object.isRequired
    onTimeUpdate: React.PropTypes.func
    onCanPlayThrough: React.PropTypes.func

  getInitialState: ->
    flip: false

  videoRef: (ref) ->
    vidElem = ReactDOM.findDOMNode(ref)
    vidElem.addEventListener 'timeupdate', (e) =>
      if @props.onTimeUpdate
        @props.onTimeUpdate(e)
    vidElem.addEventListener 'canplaythrough', (e) =>
      if @props.onCanPlayThrough
        @props.onCanPlayThrough(e)

  flip: ->
    @setState
      flip: !@state.flip

  render: ->
    flipClass = if @state.flip then 'flip' else ''
    <div>
      <a href='javascript:;' onClick={@flip}>Flip</a>
      <video controls='true' ref={@videoRef} preload='true' className={'video-player ' + flipClass}>
        <source src={@props.video.file_url}/>
      </video>
    </div>
