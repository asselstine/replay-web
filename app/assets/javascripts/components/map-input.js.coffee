class MapInput extends ComponentBase
  name: 'map-input'

  latitude: ->
    +@$latInput.val()

  longitude: ->
    +@$lngInput.val()

  coords: ->
    lat: @latitude()
    lng: @longitude()

  centerOnUser: ->
    if (navigator.geolocation)
      @$userCenterStatus.show()
      navigator.geolocation.getCurrentPosition( (position) =>
        initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
        @map.setCenter(initialLocation)
        @$userCenterStatus.hide()
      )

  constructor: (el) ->
    super(el)
    @$userCenterStatus = @$el.find('[data-user-center-status]')
    @$userCenterStatus.hide()
    @$el.find('[data-user-center-btn]').on 'click', =>
      @centerOnUser()
    @$map = @$el.find('[data-map]')
    @$latInput = @$el.find('input[data-latitude]')
    @$lngInput = @$el.find('input[data-longitude]')
    @map = new google.maps.Map(@$map[0],
      center: @coords(),
      zoom: 8
    )
    @marker = new google.maps.Marker(
      position: @coords(),
      map: @map
    )
    @map.addListener('center_changed', () =>
      center = @map.getCenter()
      @$latInput.val( center.lat() )
      @$lngInput.val( center.lng() )
      @marker.setPosition(center)
    )

window.MapInput = MapInput
