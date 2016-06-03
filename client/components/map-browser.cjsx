GoogleMapLoader = require('react-google-maps').GoogleMapLoader
GoogleMap = require('react-google-maps').GoogleMap
DraftRoute = require('./draft-route')
Marker = require('react-google-maps').Marker
_ = require('lodash')
draftLatLngs = require("../util/draft-latlngs")

module.exports = React.createClass
  displayName: 'MapBrowser'

  propTypes:
    drafts: React.PropTypes.array
    onProgressTime: React.PropTypes.func

  getDefaultProps: ->
    drafts: []

  getLatLngBounds: ->
    bounds = new google.maps.LatLngBounds()
    for draft in @props.drafts
      for latLng in draftLatLngs(draft)
        bounds.extend(latLng)
    bounds

  refGoogleMap: (ref) ->
    ref.props.map.fitBounds(@getLatLngBounds()) if ref

  render: ->
    <div className='map-browser' style={{height: '400px'}}>
      <GoogleMapLoader
        containerElement={
          <div
            {...@props.containerElementProps}
            style={{
              height: "100%",
            }}
          />
        }
        googleMapElement={
          <GoogleMap ref={@refGoogleMap}>
           {@props.drafts.map (draft) =>
             <DraftRoute draft={draft}
                         key={draft.id}
                         onProgressTime={@props.onProgressTime}/>
           }
          </GoogleMap>
        }
      />
    </div>
