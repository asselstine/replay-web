Map = require('react-leaflet').Map
TileLayer = require('react-leaflet').TileLayer
Marker = require('react-leaflet').Marker
Popup = require('react-leaflet').Popup
Polyline = require('react-leaflet').Polyline
_ = require('lodash/core')

module.exports = React.createClass
  displayName: 'MapBrowser'

  propTypes:
    drafts: React.PropTypes.array

  getDefaultProps: ->
    drafts: []
    hover: false

  getInitialState: ->
    position: [51.505, -0.09]

  handleMouseout: (e) ->
    @setState(hover: false)

  handleMouseover: (e) ->
    @setState(hover: true)

  render: ->
    line = [ [51.505, -0.09], [51.506, -0.095], [51.507, -0.1], [51.508, -0.095] ]

    weight = 20
    color = '#666'
    opacity = 0

    if @state.hover
      opacity = 0.7

    <div className='map-browser'>
      <Map center={@state.position} zoom={13}>
        <TileLayer
          url='http://{s}.tile.osm.org/{z}/{x}/{y}.png'
          attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
        />
        <Marker position={@state.position}>
          <Popup>
            <span>A pretty CSS3 popup.<br/>Easily customizable.</span>
          </Popup>
        </Marker>
        <Polyline positions={line} opacity={opacity} color={color} weight={weight}/>
        <Polyline positions={line} onMouseover={@handleMouseover} onMouseout={@handleMouseout}/>
      </Map>
    </div>
