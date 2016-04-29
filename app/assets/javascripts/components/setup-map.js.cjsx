@SetupMap = React.createClass
  displayName: 'SetupMap'

  propTypes:
    setup: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func
    readOnly: React.PropTypes.bool

  getDefaultProps: ->
    onChange: (->)
    readOnly: false

  getInitialState: ->
    latitude: +@props.setup.latitude
    longitude: +@props.setup.longitude

  coords: ->
    lat: @state.latitude
    lng: @state.longitude

  setCoords: (latitude, longitude) ->
    coords = { latitude: latitude, longitude: longitude }
    @setState(coords)
    center = new google.maps.LatLng(latitude, longitude)
    @gmarker.setPosition(center)
    @props.onChange(coords)

  centerMap: (latitude, longitude) ->
    center = new google.maps.LatLng(latitude, longitude)
    @gmap.setCenter(center)

  recenter: ->
    @gmap.setCenter(@coords())

  handleCoordUpdate: ->
    center = @gmap.getCenter()
    # console.debug('Updating center to ', center.lat(), center.lng())
    @setCoords(center.lat(), center.lng())

  mapRef: (ref) ->
    unless ref
      google.maps.event.removeListener(@windowResizeListener)
      return
    @$map = ReactDOM.findDOMNode(ref)
    options = {
      center: @coords()
      zoom: 12
      scrollwheel: false
      streetViewControl: false
    }
    if @props.readOnly
      options = $.extend(options, draggable: false)
    @gmap = new google.maps.Map(@$map, options)
    @gmarker = new google.maps.Marker(
      position: @coords(),
      map: @gmap
    )
    @windowResizeListener = google.maps.event.addDomListener(window, 'resize', @recenter)

  componentDidMount: ->
    unless @props.readOnly
      @dragListener = @gmap.addListener 'drag', @handleCoordUpdate
      @idleListener = @gmap.addListener 'idle', @handleCoordUpdate

  componentWillUnmount: ->
    google.maps.event.removeListener(@dragListener) if @dragListener
    google.maps.event.removeListener(@idleListener) if @idleListener

  centerOnUser: ->
    if (navigator.geolocation)
      @setState(busyCentering: true)
      navigator.geolocation.getCurrentPosition( (position) =>
        @setCoords(position.coords.latitude, position.coords.longitude)
        @centerMap(position.coords.latitude, position.coords.longitude)
        @setState(busyCentering: false)
      )

  render: ->
    centeringStatus = if @state.busyCentering then <span>Centering....</span>
    centerButton = <a href='javascript:;' className='btn btn-primary' onClick={@centerOnUser}>Center</a> unless @props.readOnly

    <div className='setup-map'>
      {centerButton}
      {centeringStatus}
      <div className='setup-map__gmap' ref={@mapRef}></div>
    </div>
