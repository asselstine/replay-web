SnapToRoute = require('../util/snap-to-route')
_ = require('lodash')
draftLatLngs = require('../util/draft-latlngs')

module.exports = React.createClass
  displayName: 'DraftRoute'

  propTypes:
    draft: React.PropTypes.object.isRequired
    map: React.PropTypes.object
    onProgressTime: React.PropTypes.func

  getDefaultProps: ->
    onProgressTime: (->)

  getInitialState: ->
    hover: false
    frozenLatLng: new google.maps.LatLng()
    path: draftLatLngs(@props.draft)
    onMousemove: _.throttle(@onMousemove, 50)
    hoverWeight: 20
    hoverColor: '#266'
    hoverOpacity: 0
    weight: 6
    color: '#229'
    opacity: 0.6

  getSnapToRoute: ->
    return @snapToRoute if @snapToRoute
    @snapToRoute = new SnapToRoute()
    @snapToRoute.init(@props.map, @polyline)
    @snapToRoute

  getClosestLatLng: (latLng) ->
    @getSnapToRoute().getClosestLatLng(latLng)

  getTime: (latLng) ->
    info = @getSnapToRoute().distanceToLines(latLng)
    lastTime = @props.draft.activity.timestamps_f[info.i - 1]
    nextTime = @props.draft.activity.timestamps_f[info.i]
    offset = (nextTime - lastTime) * info.fTo
    lastTime + offset

  onMouseout: (e) ->
    @setState
      hover: false
      hoverLatLng: null

  onMousemove: (e) ->
    return unless @polyline
    if google.maps.geometry.poly.isLocationOnEdge(e.latLng, @polyline, 0.0002)
      @props.onProgressTime(@getTime(e.latLng), @props.draft)
      latLng = @getClosestLatLng(e.latLng)
      @setState
        hover: true
        hoverLatLng: latLng

  handlePolylineClick: (e) ->
    console.debug('polyline clicked')
    @setState
      frozenLatLng: e.latLng

  hoverCircleRef: (ref) ->
    @hoverCircle = ref

  frozenCircleRef: (ref) ->
    @frozenCircle = ref

  handlePolyline: (ref) ->
    @polyline = ref

  componentDidMount: ->
    @hoverPolyline = new google.maps.Polyline()
    @polyline = new google.maps.Polyline()
    @eventLine = new google.maps.Polyline()
    @hoverCircle = new google.maps.Circle()
    @frozenCircle = new google.maps.Circle()

  componentWillReceiveProps: (nextProps) ->
    return unless nextProps.map
    @hoverPolyline.setMap(nextProps.map)
    @polyline.setMap(nextProps.map)
    @eventLine.setMap(nextProps.map)
    @hoverCircle.setCenter(new google.maps.LatLng())
    @hoverCircle.setRadius(4)
    @hoverCircle.setMap(nextProps.map)
    @frozenCircle.setCenter(new google.maps.LatLng())
    @frozenCircle.setRadius(4)
    @frozenCircle.setMap(nextProps.map)
    @eventLine.addListener('mousemove', @state.onMousemove)
    @eventLine.addListener('mouseout', @onMouseout)

  grender: ->
    return unless @hoverPolyline
    @hoverPolyline.setPath(@state.path)
    @polyline.setPath(@state.path)
    @eventLine.setPath(@state.path)
    @hoverCircle.setCenter(@state.hoverLatLng)
    @frozenCircle.setCenter(@state.frozenLatLng)
    @hoverPolyline.setOptions
      strokeOpacity: @state.hoverOpacity
      strokeColor: @state.hoverColor
      strokeWeight: @state.hoverWeight
    @polyline.setOptions
      strokeOpacity: @state.opacity
      strokeColor: @state.color
      strokeWeight: @state.weight
    @frozenCircle.setOptions
      strokeOpacity: 0.5
      strokeColor: '#6F6'
      strokeWeight: 10
    @hoverCircle.setOptions
      strokeOpacity: 0.5
      strokeColor: '#6F6'
      strokeWeight: 10
    @eventLine.setOptions
      strokeOpacity: 0
      strokeColor: '#00F'
      strokeWeight: 20
      zIndex: 1000

  render: ->
    if @state.hover
      hoverOpacity = 0.2
    else
      hoverOpacity = 0
    if @hoverCircle
      @hoverCircle.setOptions
        opacity: hoverOpacity

    @grender()

    <div></div>
