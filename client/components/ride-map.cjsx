module.exports = React.createClass
  propTypes:
    activity: React.PropTypes.object.isRequired

  getInitialState: ->

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
