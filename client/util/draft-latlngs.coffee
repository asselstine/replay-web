_ = require('lodash')

module.exports = (draft) ->
  inPeriod = _.filter(_.zip(draft.activity.timestamps_f,
                            draft.activity.latitudes,
                            draft.activity.longitudes), (timeLatLng) ->
                              draft.start_at_f <= timeLatLng[0] &&
                                draft.end_at_f > timeLatLng[0]
             )
  _.map(inPeriod, (timeLatLng) ->
    new google.maps.LatLng(timeLatLng[0], timeLatLng[1])
  )
