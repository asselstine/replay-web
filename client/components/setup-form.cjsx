module.exports = React.createClass
  displayName: 'SetupForm'

  propTypes:
    setup: React.PropTypes.object.isRequired

  getInitialState: ->
    name: @props.setup.name || ''
    range_m: @props.setup.range_m
    latitude: @props.setup.latitude
    longitude: @props.setup.longitude

  changeRange: (e) ->
    @setState(range_m: e.target.value)

  changeCoords: (coords) ->
    @setState(coords)

  changeName: (e) ->
    @setState(name: e.target.value)

  formRef: (form) ->
    @form = ReactDOM.findDOMNode(form)

  createSetup: (e) ->
    e.preventDefault()
    $.ajax
      method: 'POST'
      dataType: 'json'
      url: Routes.setups_path()
      data: $(e.target).serialize()
    .done (data, xhr, status) ->
      window.location = Routes.setups_path()
    .fail (xhr, status, msg) ->
      message.ajaxFail(xhr, status, msg)

  updateSetup: (e) ->
    $.ajax
      method: 'post'
      dataType: 'json'
      url: Routes.setup_path(@props.setup.id)
      data: $(e.target).serialize() + '\&_method=patch'
    .done (data, xhr, status) ->
      window.location = Routes.setups_path()
    .fail (xhr, status, msg) ->
      message.ajaxFail(xhr, status, msg)

  onSubmit: (e) ->
    e.preventDefault()
    if @props.setup.id
      @updateSetup(e)
    else
      @createSetup(e)

  render: ->
    label = if @props.setup.id then 'Save Setup' else 'Create Setup'
    <div className='setup-form'>
      <form onSubmit={@onSubmit}>
        <input name='setup[name]'
                id='setup_name'
                onChange={@changeName}
                value={@state.name} />
        <input name='setup[range_m]'
                 id='setup_range_m'
                 onChange={@changeRange}
                 value={@state.range_m}/>
        <input type='hidden' name='setup[latitude]' id='setup_latitude' value={@state.latitude} readOnly={true}/>
        <input type='hidden' name='setup[longitude]' id='setup_longitude' value={@state.longitude} readOnly={true}/>
        <button type='Submit'>{label}</button>
      </form>
      <SetupMap setup={@props.setup} onChange={@changeCoords}/>
    </div>
