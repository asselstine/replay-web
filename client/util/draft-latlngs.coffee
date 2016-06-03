_ = require('lodash')

module.exports = (draft) ->
  _.map(_.zip(draft.activity.latitudes,
              draft.activity.longitudes), (latLng) ->
    new google.maps.LatLng(latLng[0], latLng[1]))
