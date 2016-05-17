module.exports = React.createClass
  displayName: 'VideoPlayer'

  propTypes:
    video: React.PropTypes.object.isRequired
    onTimeUpdate: React.PropTypes.func
    onCanPlayThrough: React.PropTypes.func
    canFlip: React.PropTypes.bool

  getDefaultProps: ->
    canFlip: false

  getInitialState: ->
    flip: false

  videoRef: (ref) ->
    return if ref == null
    @vidElem = ReactDOM.findDOMNode(ref)
    @vidElem.addEventListener 'timeupdate', (e) =>
      if @props.onTimeUpdate
        @props.onTimeUpdate(e)
    @vidElem.addEventListener 'canplaythrough', (e) =>
      if @props.onCanPlayThrough
        @props.onCanPlayThrough(e)

  flip: ->
    @setState
      flip: !@state.flip

  render: ->
    flipClass = if @state.flip then 'flip' else ''
    flip = <a href='javascript:;' onClick={@flip}>Flip</a> if @props.canFlip
    <div>
      {flip}
      <video controls='true' ref={@videoRef} preload='true' className={'video-player ' + flipClass}>
        <source src={@props.video.file_url}/>
      </video>
    </div>
