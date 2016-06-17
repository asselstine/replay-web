SnapToRoute = require('../util/snap-to-route')
_ = require('lodash')
draftLatLngs = require('../util/draft-latlngs')
csplineLatLngs = require('../util/cspline-latlngs')

module.exports = React.createClass
  displayName: 'DraftRoute'

  propTypes:
    draft: React.PropTypes.object.isRequired
    map: React.PropTypes.object
    onProgressTime: React.PropTypes.func
    onMouseover: React.PropTypes.func
    onMouseout: React.PropTypes.func
    onClick: React.PropTypes.func

  getDefaultProps: ->
    onProgressTime: (->)
    onMouseover: (->)
    onMouseout: (->)
    onClick: (->)

  getInitialState: ->
    hover: false
    frozenLatLng: new google.maps.LatLng()
    path: draftLatLngs(@props.draft)
    splinePath: csplineLatLngs(@props.draft.activity.cspline_latlngs)
    onMousemove: _.throttle(@onMousemove, 50)
    hoverWeight: 20
    hoverColor: '#000'
    hoverOpacity: 0
    weight: 6
    color: '#229'
    opacity: 0.8
    splineLineOpacity: 0
    splineLineColor: '#F00'

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
    @props.onMouseout(e)
    @hover = false
    @setState
      hoverLatLng: null

  onMouseover: (e) ->
    @props.onMouseover(e)
    @hover = true
    @setState
      hoverLatLng: @getClosestLatLng(e.latLng)

  onMousemove: (e) ->
    return unless @polyline
    @props.onProgressTime(@getTime(e.latLng), @props.draft)
    latLng = @getClosestLatLng(e.latLng)
    @setState
      hoverLatLng: latLng

  handlePolylineClick: (e) ->
    @props.onClick(e)
    @setState
      frozenLatLng: e.latLng

  hoverCircleRef: (ref) ->
    @hoverCircle = ref

  frozenCircleRef: (ref) ->
    @frozenCircle = ref

  handlePolyline: (ref) ->
    @polyline = ref

  componentDidMount: ->
    @hoverLine = new google.maps.Polyline()
    @polyline = new google.maps.Polyline()
    @splineLine = new google.maps.Polyline()
    @eventLine = new google.maps.Polyline()
    @hoverCircle = new google.maps.Circle()
    @frozenCircle = new google.maps.Circle()

  componentWillReceiveProps: (nextProps) ->
    return unless nextProps.map
    @hoverLine.setMap(nextProps.map)
    @polyline.setMap(nextProps.map)
    @splineLine.setMap(nextProps.map)
    @eventLine.setMap(nextProps.map)
    @hoverCircle.setCenter(new google.maps.LatLng())
    @hoverCircle.setRadius(4)
    @hoverCircle.setMap(nextProps.map)
    @frozenCircle.setCenter(new google.maps.LatLng())
    @frozenCircle.setRadius(4)
    @frozenCircle.setMap(nextProps.map)
    @eventLine.addListener('mousemove', @state.onMousemove)
    @eventLine.addListener('mouseout', @onMouseout)
    @eventLine.addListener('click', @handlePolylineClick)
    @eventLine.addListener('mouseover', @onMouseover)

  render: ->
    if @hover
      hoverLineOpacity = 0.1
      hoverCircleOpacity = 0.5
    else
      hoverLineOpacity = 0
      hoverCircleOpacity = 0

    console.debug('opacity: ', hoverLineOpacity, hoverCircleOpacity)

    if @hoverLine
      @splineLine.setPath(@state.splinePath)
      @splineLine.setOptions
        strokeOpacity: @state.splineLineOpacity
        strokeColor: @state.splineLineColor
      @hoverLine.setPath(@state.path)
      @polyline.setPath(@state.path)
      @eventLine.setPath(@state.path)
      @hoverCircle.setCenter(@state.hoverLatLng)
      @frozenCircle.setCenter(@state.frozenLatLng)
      @hoverLine.setOptions
        strokeOpacity: hoverLineOpacity
        strokeColor: @state.hoverColor
        strokeWeight: @state.hoverWeight
      @polyline.setOptions
        strokeOpacity: @state.opacity
        strokeColor: '#' + @props.draft.activity.colour
        strokeWeight: @state.weight
      @frozenCircle.setOptions
        strokeOpacity: 0.5
        strokeColor: '#6F6'
        strokeWeight: 10
      @hoverCircle.setOptions
        opacity: hoverCircleOpacity
        strokeOpacity: hoverCircleOpacity
        fillOpacity: hoverCircleOpacity
        strokeColor: '#6F6'
        strokeWeight: 10
      @eventLine.setOptions
        strokeOpacity: 0
        strokeColor: '#00F'
        strokeWeight: 20
        zIndex: 1000

    <div></div>
