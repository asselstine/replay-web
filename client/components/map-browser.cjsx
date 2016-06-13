DraftRoute = require('./draft-route')
_ = require('lodash')
draftLatLngs = require("../util/draft-latlngs")

module.exports = React.createClass
  displayName: 'MapBrowser'

  propTypes:
    drafts: React.PropTypes.array
    onProgressTime: React.PropTypes.func

  getDefaultProps: ->
    drafts: []

  getInitialState: ->
    map: null

  getLatLngBounds: ->
    bounds = new google.maps.LatLngBounds()
    for draft in @props.drafts
      for latLng in draftLatLngs(draft)
        bounds.extend(latLng)
    bounds

  googleMapRef: (ref) ->
    return unless ref
    @ref = ReactDOM.findDOMNode(ref)
    @googleMap = new google.maps.Map(@ref,
      scrollwheel: false,
      streetViewControl: false
    )
    @googleMap.fitBounds(@getLatLngBounds())

  componentDidMount: ->
    @setState
      map: @googleMap

  render: ->
    <div className='map-browser'>
      <div style={{height: '400px'}} ref={@googleMapRef}>
      </div>
      {@props.drafts.map (draft) =>
        <DraftRoute key={draft.id}
                    map={@state.map}
                    draft={draft}
                    onProgressTime={@props.onProgressTime}/>
      }
    </div>
