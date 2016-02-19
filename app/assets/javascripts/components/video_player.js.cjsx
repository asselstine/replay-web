@VideoPlayer = React.createClass
  displayName: 'VideoPlayer'

  propTypes:
    video: React.PropTypes.object.isRequired
    onTimeUpdate: React.PropTypes.func
    onCanPlayThrough: React.PropTypes.func

  videoRef: (ref) ->
    vidElem = ReactDOM.findDOMNode(ref)
    vidElem.addEventListener 'timeupdate', (e) =>
      if @props.onTimeUpdate
        @props.onTimeUpdate(e)
    vidElem.addEventListener 'canplaythrough', (e) =>
      if @props.onCanPlayThrough
        @props.onCanPlayThrough(e)

  render: ->
    <video controls='true' ref={@videoRef} preload='true'>
      <source src={@props.video.file_url}/>
    </video>
