Polyline = require('react-google-maps').Polyline
Circle = require('react-google-maps').Circle
SnapToRoute = require('../util/snap-to-route')
_ = require('lodash')
draftLatLngs = require('../util/draft-latlngs')

module.exports = React.createClass
  displayName: 'DraftRoute'

  propTypes:
    draft: React.PropTypes.object.isRequired
    onProgressTime: React.PropTypes.func

  getDefaultProps: ->
    onProgressTime: (->)

  getInitialState: ->
    hover: false
    frozenLatLng: new google.maps.LatLng()
    path: draftLatLngs(@props.draft)
    onMousemove: _.throttle(@onMousemove, 50)

  getSnapToRoute: ->
    return @snapToRoute if @snapToRoute
    @snapToRoute = new SnapToRoute()
    @snapToRoute.init(@map(), @gPolyline())
    @snapToRoute

  getClosestLatLng: (latLng) ->
    @getSnapToRoute().getClosestLatLng(latLng)

  getTime: (latLng) ->
    info = @getSnapToRoute().distanceToLines(latLng)
    lastTime = @props.draft.activity.timestamps_f[info.i - 1]
    nextTime = @props.draft.activity.timestamps_f[info.i]
    offset = (nextTime - lastTime) * info.fTo
    lastTime + offset

  map: ->
    @props.mapHolderRef.props.map

  gPolyline: ->
    @polyline.state.polyline

  onMouseout: (e) ->
    @setState
      hover: false
      hoverLatLng: null, =>
        @grender()

  onMousemove: (e) ->
    return unless @polyline
    if google.maps.geometry.poly.isLocationOnEdge(e.latLng, @gPolyline(), 0.0002)
      @props.onProgressTime(@getTime(e.latLng), @props.draft)
      latLng = @getClosestLatLng(e.latLng)
      @setState
        hover: true
        hoverLatLng: latLng, =>
          @grender()

  handlePolylineClick: (e) ->
    console.debug('polyline clicked')
    @setState
      frozenLatLng: e.latLng

  hoverCircleRef: (ref) ->
    @hoverCircle = ref

  frozenCircleRef: (ref) ->
    @frozenCircle = ref

  grender: () ->
    if @state.hover
      hoverOpacity = 0.2
    else
      hoverOpacity = 0
    @hoverCircle.state.circle.setOptions
      opacity: hoverOpacity
    @hoverCircle.state.circle.setCenter(@state.hoverLatLng)
    @frozenCircle.state.circle.setCenter(@state.frozenLatLng)

  handlePolyline: (ref) ->
    @polyline = ref

  render: ->
    hoverWeight = 20
    hoverColor = '#266'
    hoverOpacity = 0

    weight = 6
    color = '#229'
    opacity = 0.6

    <div>
      <Polyline key='hover'
                mapHolderRef={@props.mapHolderRef}
                path={@state.path}
                options={
                    strokeOpacity: hoverOpacity
                    strokeColor: hoverColor
                    strokeWeight: hoverWeight
                }
                />
      <Polyline key='route'
                mapHolderRef={@props.mapHolderRef}
                path={@state.path}
                ref={@handlePolyline}
                options={
                    strokeOpacity: opacity
                    strokeColor: color
                    strokeWeight: weight
                }
                onClick={@handlePolylineClick}/>
      <Circle ref={@frozenCircleRef}
             mapHolderRef={@props.mapHolderRef}
             center={ new google.maps.LatLng() }
             radius={8}
             options={
               strokeOpacity: 1
               strokeColor: '#FFF'
               strokeWeight: 10
               zIndex: 1000
             }
             onClick={@handlePolylineClick}/>
      <Circle ref={@hoverCircleRef}
              mapHolderRef={@props.mapHolderRef}
              center={ new google.maps.LatLng() }
              radius={8}
              options={
                strokeOpacity: 0.5
                strokeColor: '#6F6'
                strokeWeight: 10
              }
              onClick={@handlePolylineClick}/>
      <Polyline key='fat_event_line'
                mapHolderRef={@props.mapHolderRef}
                path={@state.path}
                options={
                    strokeOpacity: 0
                    strokeColor: '#000'
                    strokeWeight: 30
                    zIndex: 1000
                }
                onMousemove={@state.onMousemove}
                onMouseout={@onMouseout}
                />
    </div>
