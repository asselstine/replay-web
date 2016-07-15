_ = require('lodash')

module.exports = (draft) ->
  _.map(_.zip(draft.latitudes, draft.longitudes), (timeLatLng) ->
    new google.maps.LatLng(timeLatLng[0], timeLatLng[1])
  )
