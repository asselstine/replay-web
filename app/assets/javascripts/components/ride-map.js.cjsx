@RideMap = React.createClass
  propTypes:
    ride: React.PropTypes.object.isRequired

  getInitialState: ->
    coords; ride.interpolated_coords.first ||

  initMap: (comp) ->
    @$map = $(React.findDOMNode(comp))
    @gmap = new google.maps.Map(@$map[0],
      center: @coords(),
      zoom: 16,
      scrollwheel: false,
      streetViewControl: false
    )

  render: ->
    <div>
      <div ref='initMap'></div>
    </div>
