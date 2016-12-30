_ = require('lodash')

module.exports = (latitudes, longitudes) ->
  _.map(_.zip(latitudes, longitudes), (latLng) ->
    new google.maps.LatLng(latLng[0], latLng[1])
  )
