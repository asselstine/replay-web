module.exports = React.createClass
  displayName: 'Map'

  propTypes:
    bounds: React.PropTypes.object

  childContextTypes:
    map: React.PropTypes.object

  getChildContext: ->
    map: @googleMap

  getInitialState: ->
    map: null

  componentWillReceiveProps: (nextProps) ->
    @googleMap.fitBounds(nextProps.bounds) if nextProps.bounds

  componentDidMount: ->
    google.maps.event.addDomListener(window, 'resize', @fitBounds)

  componentWillUnmount: ->
    google.maps.event.removeDomListener(window, 'resize', @fitBounds)

  fitBounds: ->
    @googleMap.fitBounds(@props.bounds) if @props.bounds

  googleMapRef: (ref) ->
    return unless ref
    @ref = ReactDOM.findDOMNode(ref)
    @googleMap = new google.maps.Map(@ref,
      scrollwheel: false,
      streetViewControl: false,
      disableDefaultUI: true,
      scrollwheel: false,
      disableDoubleClickZoom: true,
      panControl: false,
      draggable: false,
      streetViewControl: false,
      zoom: 7,
      center: {lat: -34, lng: 151}
    )
    @googleMap.fitBounds(@props.bounds) if @props.bounds
    @setState
      map: @googleMap

  render: ->
    <div className='map'>
      <div style={{paddingBottom: '100%'}} ref={@googleMapRef}>
      </div>
      {@props.children}
    </div>
