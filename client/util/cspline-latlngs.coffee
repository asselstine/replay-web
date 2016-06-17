module.exports = (latlngs) ->
  latlngs.map (latLng) ->
    { lat: latLng[0], lng: latLng[1] }
