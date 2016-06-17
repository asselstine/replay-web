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
    if ref == null
      @vidElem = null
    else
      @vidElem = ReactDOM.findDOMNode(ref)

  seek: (time) ->
    @vidElem.currentTime = time

  flip: ->
    @setState
      flip: !@state.flip

  videoTimeUpdate: (e) ->
    if @props.onTimeUpdate
      @props.onTimeUpdate(e)

  videoCanPlayThrough: (e) ->
    if @props.onCanPlayThrough
      @props.onCanPlayThrough(e)

  componentDidMount: ->
    @vidElem.addEventListener 'timeupdate', @videoTimeUpdate
    @vidElem.addEventListener 'canplaythrough', @videoCanPlayThrough

  componentWillUnmount: ->
    return unless @vidElem
    @vidElem.removeEventListener 'timeupdate', @videoTimeUpdate
    @vidElem.removeEventListener 'canplaythrough', @videoCanPlayThrough

  render: ->
    flipClass = if @state.flip then 'flip' else ''
    flip = <a className='btn btn-primary' href='javascript:;' onClick={@flip}>Flip</a> if @props.canFlip
    <div>
      <div className='video-container'>
        <video controls='true'
               ref={@videoRef}
               preload='false'
               className={'video-player ' + flipClass}
               poster={@props.video.thumbnail.url}>
          <source src={@props.video.file_url}/>
        </video>
      </div>
      {flip}
    </div>
