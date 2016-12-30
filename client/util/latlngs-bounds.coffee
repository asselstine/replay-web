module.exports = (latLngs) ->
  bounds = new google.maps.LatLngBounds()
  for latLng in latLngs
    bounds.extend(latLng)
  bounds
