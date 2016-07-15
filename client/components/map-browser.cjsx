DraftRoute = require('./draft-route')
_ = require('lodash')
draftLatLngs = require("../util/draft-latlngs")

module.exports = React.createClass
  displayName: 'MapBrowser'

  propTypes:
    drafts: React.PropTypes.array

  childContextTypes:
    map: React.PropTypes.object

  getChildContext: ->
    map: @googleMap

  getDefaultProps: ->
    drafts: []

  getInitialState: ->
    map: null

  getDraftLatLngs: ->
    latLngs = []
    for draft in @props.drafts
      for latLng in draftLatLngs(draft)
        latLngs.push(latLng)
    latLngs

  getLatLngBounds: ->
    bounds = new google.maps.LatLngBounds()
    for latLng in @getDraftLatLngs()
      bounds.extend(latLng)
    bounds

  googleMapRef: (ref) ->
    return unless ref
    @ref = ReactDOM.findDOMNode(ref)
    @googleMap = new google.maps.Map(@ref,
      scrollwheel: false,
      streetViewControl: false,
      zoom: 7,
      center: {lat: -34, lng: 151}
    )
    @googleMap.fitBounds(@getLatLngBounds())
    @setState
      map: @googleMap

  render: ->
    <div className='map-browser'>
      <div style={{height: '400px'}} ref={@googleMapRef}>
      </div>
      {@props.children}
    </div>
