@NewCurrentSetupButton = React.createClass
  displayName: 'NewCurrentSetupButton'

  getInitialState: ->
    canGeolocate: navigator.geolocation

  handleCurrentPosition: (position) ->
    $.ajax
      type: 'post',
      url: Routes.setup_path,
      data: {
          'setup[latitude]': position.coords.latitude,
          'setup[longitude]': position.coords.longitude
      }
    .done(data, xhr, status) =>
      message.success('Created setup')
    .fail(xhr, status, message) =>
      message.ajaxFail(xhr, status, message)

  create: ->
    @setState warning: null
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition(@handleCurrentPosition.bind(@))
    else
      @setState warning: I18n.t('component.NewCurrentSetupButton.warning')
  render: ->
    alert = <div className='alert alert-danger'>{@state.warning}</div> if @state.warning
    <div>
      {alert}
      <a onClick={@create} href='#'>New Camera Setup from my Location</a>
    </div>
