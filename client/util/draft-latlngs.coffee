ziplatlng = require('./zip-latlng')

module.exports = (draft) ->
  ziplatlng(draft.latitudes, draft.longitudes)
