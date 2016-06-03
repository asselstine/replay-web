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
    path: draftLatLngs(@props.draft)

  getClosestLatLng: (latLng) ->
    snapToRoute = new SnapToRoute()
    snapToRoute.init(@map(), @gPolyline())
    snapToRoute.getClosestLatLng(latLng)

  getTime: (latLng) ->
    snapToRoute = new SnapToRoute()
    snapToRoute.init(@map(), @gPolyline())
    info = snapToRoute.distanceToLines(latLng)
    lastTime = @props.draft.activity.timestamps_f[info.i - 1]
    nextTime = @props.draft.activity.timestamps_f[info.i]
    offset = (nextTime - lastTime) * info.fTo
    lastTime + offset

  componentDidMount: ->
    @mapMousemoveHandle = @map().addListener('mousemove', @handleMapMousemove)

  componentWillUnmount: ->
    google.maps.event.removeListener(@mapMousemoveHandle) if @mapMousemoveHandle

  map: ->
    @props.mapHolderRef.props.map

  gPolyline: ->
    @polyline.state.polyline

  handleMapMousemove: (e) ->
    return unless @polyline
    if google.maps.geometry.poly.isLocationOnEdge(e.latLng, @gPolyline(), 0.001)
      @props.onProgressTime(@getTime(e.latLng), @props.draft)
      @setState
        hover: true
        hoverLatLng: @getClosestLatLng(e.latLng)
    else
      @setState
        hover: false
        hoverLatLng: null

  handlePolyline: (ref) ->
    @polyline = ref

  render: ->
    hoverWeight = 20
    hoverColor = '#666'
    hoverOpacity = 0

    hoverCircle = ''
    if @state.hover
      hoverOpacity = 0.5
      hoverCircle = <Circle mapHolderRef={@props.mapHolderRef}
                            center={@state.hoverLatLng}
                            radius={0.1}
                            options={
                              strokeOpacity: 1
                              strokeColor: '#FFF'
                              strokeWeight: 10
                            }
                            onMousemove={@handleMapMousemove}/>

    weight = 6
    color = '#229'
    opacity = 0.6

    <div>
      <Polyline mapHolderRef={@props.mapHolderRef}
                path={@state.path}
                options={
                    strokeOpacity: hoverOpacity
                    strokeColor: hoverColor
                    strokeWeight: hoverWeight
                }
                onMousemove={@handleMapMousemove}/>
      {hoverCircle}
      <Polyline mapHolderRef={@props.mapHolderRef}
                path={@state.path}
                ref={@handlePolyline}
                options={
                    strokeOpacity: opacity
                    strokeColor: color
                    strokeWeight: weight
                }
                onMousemove={@handleMapMousemove}/>
    </div>
